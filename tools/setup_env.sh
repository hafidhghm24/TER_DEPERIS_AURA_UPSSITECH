#!/usr/bin/env bash
# Usage:
#   source ./tools/setup_env.sh          (configure l'environnement et compile si workspace ROS 2)
#   source ./tools/setup_env.sh --deps   (installe aussi les dependances rosdep / pip)

if [ -n "${ZSH_VERSION:-}" ]; then
    SHELL_EXT="zsh"
    SCRIPT_PATH="${(%):-%x}"
else
    SHELL_EXT="bash"
    SCRIPT_PATH="${BASH_SOURCE[0]}"
fi

REPO_ROOT="$(cd "$(dirname "$SCRIPT_PATH")/.." && pwd)"
INSTALL_DEPS=false
[ "${1:-}" = "--deps" ] && INSTALL_DEPS=true

# Detection de packages ROS dans src/
HAS_ROS_PKG=false
if [ -d "$REPO_ROOT/src" ] && [ -n "$(find "$REPO_ROOT/src" -maxdepth 3 -name 'package.xml' -print -quit 2>/dev/null)" ]; then
    HAS_ROS_PKG=true
fi

if [ "$HAS_ROS_PKG" = true ]; then
    # Desactivation complete de Conda pour eviter les conflits avec CMake / ROS 2
    while [ "${CONDA_SHLVL:-0}" -gt 0 ]; do
        conda deactivate
    done

    # Detection de la distribution ROS 2
    ROS_FOUND=""
    for distro in "${ROS_DISTRO:-}" jazzy humble iron rolling kilted foxy; do
        if [ -n "$distro" ] && [ -f "/opt/ros/$distro/setup.$SHELL_EXT" ]; then
            ROS_FOUND="$distro"
            break
        fi
    done

    if [ -n "$ROS_FOUND" ]; then
        source "/opt/ros/$ROS_FOUND/setup.$SHELL_EXT"
        echo "[INFO] ROS 2 $ROS_FOUND active."
    else
        echo "[WARN] Aucun environnement ROS 2 trouve dans /opt/ros."
    fi

    if [ "$INSTALL_DEPS" = true ] && command -v rosdep >/dev/null 2>&1; then
        (cd "$REPO_ROOT" && rosdep install --from-paths src --ignore-src -r -y)
    fi

    if command -v colcon >/dev/null 2>&1; then
        (cd "$REPO_ROOT" && colcon build --symlink-install)
        if [ -f "$REPO_ROOT/install/local_setup.$SHELL_EXT" ]; then
            source "$REPO_ROOT/install/local_setup.$SHELL_EXT"
            echo "[INFO] Workspace ROS 2 compile et source."
        fi
    fi
else
    # Projet standard (non-ROS ou aucun package dans src/) : activation de .venv si present
    if [ -f "$REPO_ROOT/.venv/bin/activate" ]; then
        source "$REPO_ROOT/.venv/bin/activate"
        echo "[INFO] Environnement virtuel Python (.venv) active."
        if [ "$INSTALL_DEPS" = true ] && [ -f "$REPO_ROOT/requirements.txt" ]; then
            pip install -r "$REPO_ROOT/requirements.txt"
        fi
    else
        echo "[INFO] Aucun package ROS detecte dans src/ et aucun .venv present."
    fi
fi
