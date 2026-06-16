#!/bin/bash

set -e
set -o nounset
set -o pipefail

if [ $# -ne 1 ]; then
    echo "Syntax: $0 <workspace_dir>"
    exit 255
fi

WORKSPACE_DIR=$1
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PATCH_DIR=""

for candidate in \
    "${SCRIPT_DIR}/../../share/micro_ros_setup/patches" \
    "${SCRIPT_DIR}/../share/micro_ros_setup/patches" \
    "${SCRIPT_DIR}/../patches"
do
    if [ -d "${candidate}" ]; then
        PATCH_DIR="${candidate}"
        break
    fi
done

if [ ! -d "${WORKSPACE_DIR}" ]; then
    echo "Error: Workspace '${WORKSPACE_DIR}' does not exist"
    exit 255
fi

if [ -z "${PATCH_DIR}" ]; then
    echo "Error: Patch directory not found (searched: ${SCRIPT_DIR}/../../share/micro_ros_setup/patches, ${SCRIPT_DIR}/../share/micro_ros_setup/patches, ${SCRIPT_DIR}/../patches)"
    exit 255
fi

apply_patch_file() {
    local patch_file=$1

    if patch --batch --forward -p1 -d "${WORKSPACE_DIR}" --dry-run < "${patch_file}" >/dev/null 2>&1; then
        echo "Applying $(basename "${patch_file}")"
        patch --batch --forward -p1 -d "${WORKSPACE_DIR}" < "${patch_file}" >/dev/null
        return
    fi

    if patch --batch --reverse -p1 -d "${WORKSPACE_DIR}" --dry-run < "${patch_file}" >/dev/null 2>&1; then
        echo "Skipping $(basename "${patch_file}") (already applied)"
        return
    fi

    echo "Error: Failed to apply $(basename "${patch_file}") in ${WORKSPACE_DIR}"
    exit 1
}

shopt -s nullglob
for patch_file in "${PATCH_DIR}"/*.patch; do
    apply_patch_file "${patch_file}"
done
