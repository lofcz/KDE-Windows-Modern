#!/usr/bin/env bash
# Build the matching PLM release without discarding local source changes.
set -euo pipefail
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
PLM_DIR="$SRC_DIR/third_party/plasma-login-manager"
PATCH="$SRC_DIR/plasma/look-and-feel/org.kde.windowsmodern.dark/patches/main-cpp.patch"
BUILD_DIR="${WM_GREETER_BUILD_DIR:-$PLM_DIR/build-user}"
THEME_SRC="$SRC_DIR/plasma/look-and-feel/org.kde.windowsmodern.dark/contents/lockscreen"
THEME_DST="$HOME/.local/share/plasma/look-and-feel/org.kde.windowsmodern.dark/contents/lockscreen"

if [ "$(git -C "$PLM_DIR" rev-parse --show-toplevel 2>/dev/null || true)" != "$PLM_DIR" ]; then
    echo 'Initialize third_party/plasma-login-manager before building.' >&2
    exit 1
fi

applied=0
cleanup() {
    if [ "$applied" = 1 ]; then
        patch --batch -R -d "$PLM_DIR" -p1 < "$PATCH"
    fi
}
trap cleanup EXIT
if patch --batch --dry-run -d "$PLM_DIR" -p1 < "$PATCH" >/dev/null 2>&1; then
    patch --batch -d "$PLM_DIR" -p1 < "$PATCH"
    applied=1
elif ! patch --batch --dry-run -R -d "$PLM_DIR" -p1 < "$PATCH" >/dev/null 2>&1; then
    echo 'The greeter patch does not apply. Source changes were preserved.' >&2
    exit 1
fi

libexec=libexec
if [ -f /usr/lib/plasma-login-greeter ]; then libexec=lib; fi
cmake -S "$PLM_DIR" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr -DKDE_INSTALL_LIBEXECDIR="$libexec"
cmake --build "$BUILD_DIR" --target plasma-login-greeter --parallel "${WM_BUILD_JOBS:-4}"

mkdir -p "$THEME_DST"
rsync -a --delete "$THEME_SRC/" "$THEME_DST/"
printf 'Built: %s/bin/plasma-login-greeter\n' "$BUILD_DIR"
printf 'Test with: WINDOWS_MODERN_GREETER_THEME=%q %q --test\n' "$THEME_DST/Main.qml" "$BUILD_DIR/bin/plasma-login-greeter"
echo 'The active login manager and graphical session were left running.'
