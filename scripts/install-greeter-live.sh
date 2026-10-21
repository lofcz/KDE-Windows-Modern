#!/usr/bin/env bash
# Install a previously built greeter atomically; never stop the display manager.
set -euo pipefail
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
BUILD_DIR="${WM_GREETER_BUILD_DIR:-$SRC_DIR/third_party/plasma-login-manager/build-user}"
BUILT="$BUILD_DIR/bin/plasma-login-greeter"
TARGET=/usr/libexec/plasma-login-greeter
if [ -f /usr/lib/plasma-login-greeter ]; then TARGET=/usr/lib/plasma-login-greeter; fi
[ -x "$BUILT" ] || { echo "Build the greeter first: $SRC_DIR/scripts/install-greeter.sh" >&2; exit 1; }
if [ "$EUID" -ne 0 ]; then
    exec sudo env WM_GREETER_BUILD_DIR="$BUILD_DIR" bash "$0" "$@"
fi

# Refuse an unresolved binary before changing the next-login executable.
dependencies="$(ldd -r "$BUILT" 2>&1)" || { echo 'Cannot inspect greeter dependencies.' >&2; exit 1; }
if [[ "$dependencies" == *'not found'* || "$dependencies" == *'undefined symbol'* ]]; then
    echo 'The built greeter has unresolved dependencies; installation aborted.' >&2
    exit 1
fi
BACKUP="${TARGET}.orig-$(date -u +%Y%m%dT%H%M%SZ)"
cp -a "$TARGET" "$BACKUP"
SYSTEM_THEME=/usr/share/plasma/look-and-feel/org.kde.windowsmodern.dark
mkdir -p "$SYSTEM_THEME/contents/lockscreen" /usr/share/wallpapers/Windows-modern
rsync -a --delete "$SRC_DIR/plasma/look-and-feel/org.kde.windowsmodern.dark/contents/lockscreen/" "$SYSTEM_THEME/contents/lockscreen/"
rsync -a "$SRC_DIR/wallpaper/Windows-modern/" /usr/share/wallpapers/Windows-modern/
install -m 755 "$BUILT" "${TARGET}.windows-modern-new"
mv -Tf "${TARGET}.windows-modern-new" "$TARGET"
printf 'Installed for the next login. Backup: %s\n' "$BACKUP"
echo 'The login manager and current session remain running.'
