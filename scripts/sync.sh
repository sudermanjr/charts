#!/usr/bin/env bash

# Copyright 2018 The Kubernetes Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

readonly HELM_URL=https://get.helm.sh
readonly HELM_TARBALL=helm-v3.2.1-linux-amd64.tar.gz
readonly REPO_URL=https://charts.sudermanjr.com

readonly S3_BUCKET=s3://charts.sudermanjr.com

main() {
    authenticate

    if ! sync_repo "$S3_BUCKET" "$REPO_URL"; then
        log_error "Not all charts could be packaged and synced!"
    fi
}

setup_helm_client() {
    echo "Setting up Helm client..."

    curl --user-agent curl-ci-sync -sSL -o "$HELM_TARBALL" "$HELM_URL/$HELM_TARBALL"
    tar xzfv "$HELM_TARBALL"

    PATH="$(pwd)/linux-amd64/:$PATH"
    helm repo add stable https://kubernetes-charts.storage.googleapis.com
}

authenticate() {
    echo "Checking AWS Authentication"
    aws sts get-caller-identity
}

sync_repo() {
    local bucket="${1?Specify repo bucket}"
    local repo_url="${2?Specify repo url}"
    local sync_dir="sync"
    local index_dir="index"

    echo "Syncing repo ..."

    mkdir -p "$sync_dir"
    if ! aws s3 cp "$bucket/index.yaml" "$index_dir/index.yaml"; then
        log_error "Exiting because unable to copy index locally. Not safe to proceed."
        exit 1
    fi

    local exit_code=0

    for dir in charts/*; do
        if helm dependency build "$dir"; then
            helm package --destination "$sync_dir" "$dir"
        else
            log_error "Problem building dependencies. Skipping packaging of '$dir'."
            exit_code=1
        fi
    done

    if helm repo index --url "$repo_url" --merge "$index_dir/index.yaml" "$sync_dir"; then
        # Move updated index.yaml to sync folder so we don't push the old one again
        mv -f "$sync_dir/index.yaml" "$index_dir/index.yaml"

        aws s3 sync --exclude index.yaml "$sync_dir" "$bucket"

        # Make sure index.yaml is synced last
        aws s3 cp "$index_dir/index.yaml" "$bucket/index.yaml"
        aws s3 cp "index.html" "$bucket/index.html"
    else
        log_error "Exiting because unable to update index. Not safe to push update."
        exit 1
    fi

    ls -l "$sync_dir"

    return "$exit_code"
}

log_error() {
    printf '\e[31mERROR: %s\n\e[39m' "$1" >&2
}

main
