#!/bin/bash
# ───────────────────────────────────────────────────────────────────
#  install-sessionlock.sh — Session lock screen (Meta+L / kscreenlocker)
#
#  kscreenlocker resolves the lock screen from the CURRENT desktop shell
#  package (org.kde.plasma.desktop). To theme Meta+L we create a COMPLETE
#  user-level overlay of that shell. Copy lockscreen and logout into the
#  package; link the remaining system contents so they follow Plasma updates.
#
#  The shell MUST remain complete. An incomplete shell triggers the ugly
#  Qt widget fallback. On uninstall, delete the ENTIRE user shell dir.
# ───────────────────────────────────────────────────────────────────
source "$(dirname "$0")/install-lib.sh"
source "$(dirname "$0")/shell-overlay.sh"

SHELL_SRC="$SRC_DIR/plasma/shells/org.kde.windowsmodern.lockscreen"
USER_SHELLS="$HOME/.local/share/plasma/shells"
OVERLAY_SHELL="$USER_SHELLS/org.kde.plasma.desktop"
SYSTEM_SHELL="/usr/share/plasma/shells/org.kde.plasma.desktop"

info "Installing Windows Modern session lock screen (Meta+L)..."

# ── 1. Sanity-check system shell exists ──
if [ ! -d "$SYSTEM_SHELL" ]; then
    err "System shell not found at $SYSTEM_SHELL"
    err "This theme requires the default Plasma desktop shell package."
    exit 1
fi
if [ ! -d "$SHELL_SRC/contents/lockscreen" ]; then
    err "Custom lockscreen source not found at $SHELL_SRC/contents/lockscreen"
    exit 1
fi

# ── 2. Backup and remove any broken/incomplete user shell override ──
if [ -d "$OVERLAY_SHELL" ]; then
    BACKUP_NAME="org.kde.plasma.desktop.bak.$(date +%Y%m%d%H%M%S)"
    step "Backing up existing overlay → $BACKUP_NAME"
    mv "$OVERLAY_SHELL" "$USER_SHELLS/$BACKUP_NAME"
fi

# ── 3. Install a complete shell with local lockscreen and logout assets ──
step "Creating user shell overlay..."
install_shell_overlay "$SYSTEM_SHELL" "$SHELL_SRC" "$OVERLAY_SHELL"

# ── 5. Reset kscreenlockerrc so it doesn't point to a non-existent standalone shell ──
kwriteconfig6 --file kscreenlockerrc --group Greeter --key Theme --delete 2>/dev/null || true

# ── 6. Rebuild cache ──
kbuildsycoca6 2>/dev/null || true

# ── 7. Clear QML caches ──
rm -rf ~/.cache/qmlcache ~/.cache/QtProject/qmlcache 2>/dev/null || true

echo ""
info "Windows Modern session lock screen installed."
echo "  Press ${BOLD}Meta+L${RESET} to test."
echo ""
echo "  Test safely without locking:  /usr/libexec/kscreenlocker_greet --testing"
echo ""
warn "If you see the ugly Qt fallback, run:  ./uninstall.sh sessionlock"
warn "This restores Breeze immediately."
