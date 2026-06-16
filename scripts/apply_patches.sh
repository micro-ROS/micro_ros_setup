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

patch_targets_workspace() {
    local patch_file=$1
    local candidate_path=""
    local repo_path=""
    local saw_diff=0

    while read -r _ _ old_path new_path; do
        saw_diff=1
        old_path=${old_path#a/}
        new_path=${new_path#b/}

        for candidate_path in "${old_path}" "${new_path}"; do
            repo_path=$(printf '%s\n' "${candidate_path}" | cut -d/ -f1-2)
            if [ -n "${repo_path}" ] && [ -d "${WORKSPACE_DIR}/${repo_path}" ]; then
                return 0
            fi
        done
    done < <(grep '^diff --git a/' "${patch_file}" || true)

    if [ "${saw_diff}" -eq 0 ]; then
        return 0
    fi

    return 1
}

apply_patch_file() {
    local patch_file=$1

    if ! patch_targets_workspace "${patch_file}"; then
        echo "Skipping $(basename "${patch_file}") (workspace does not contain the patched repository)"
        return
    fi

    if patch --batch --forward -p1 -d "${WORKSPACE_DIR}" --dry-run < "${patch_file}" >/dev/null 2>&1; then
        echo "Applying $(basename "${patch_file}")"
        patch --batch --forward -p1 -d "${WORKSPACE_DIR}" < "${patch_file}" >/dev/null
        return
    fi

    if patch --batch --reverse -p1 -d "${WORKSPACE_DIR}" --dry-run < "${patch_file}" >/dev/null 2>&1; then
        echo "Skipping $(basename "${patch_file}") (already applied)"
        return
    fi

    echo "Warning: Failed to apply $(basename "${patch_file}") in ${WORKSPACE_DIR}" >&2
}

shopt -s nullglob
for patch_file in "${PATCH_DIR}"/*.patch; do
    apply_patch_file "${patch_file}"
done
