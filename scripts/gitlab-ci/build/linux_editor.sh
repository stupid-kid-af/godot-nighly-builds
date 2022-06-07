#!/usr/bin/env bash
#
# This build script is licensed under CC0 1.0 Universal:
# https://creativecommons.org/publicdomain/zero/1.0/

set -euo pipefail
IFS=$'\n\t'

export DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$DIR/../_common.sh"

# Required to find pip-installed SCons
export PATH="$HOME/.local/bin:$PATH"
sudo apt-get install build-essential scons pkg-config libx11-dev libxcursor-dev libxinerama-dev \
    libgl1-mesa-dev libglu-dev libasound2-dev libpulse-dev libudev-dev libxi-dev libxrandr-dev yasm
# Build Linux editor
# Use recent GCC provided by the Ubuntu Toolchain PPA.
cd godot
scons platform=linuxbsd tools=yes target=debug \
      udev=yes use_static_cpp=yes \
      CC="gcc-9" CXX="g++-9" "${SCONS_FLAGS[@]}"

# Create Linux editor ZIP archive.
cd bin/
mv "godot.linuxbsd.tools.64" "godot"
cd ..
zip -r9 "$ARTIFACTS_DIR/editor/godot-linux-nightly-x86_64.zip" "godot"

make_manifest "$ARTIFACTS_DIR/editor/godot-linux-nightly-x86_64.zip"
