#!/usr/bin/env bash
# Assemble the shell without changing the running session or user settings.
install_shell_overlay() {
    local system_shell="$1" custom_shell="$2" overlay_shell="$3"
    local item base

    mkdir -p "$overlay_shell/contents"
    cp "$system_shell/metadata.json" "$overlay_shell/"

    for item in "$system_shell/contents/"*; do
        base=$(basename "$item")
        case "$base" in
            lockscreen) continue ;;
            logout)
                # Plasma 6.8 resolves logoutmainscript from Plasma/Shell.
                # KPackage rejects symlinks outside the package in the greeter.
                cp -rL "$item" "$overlay_shell/contents/logout"
                ;;
            *) ln -s "$item" "$overlay_shell/contents/$base" ;;
        esac
    done

    cp -rL "$custom_shell/contents/lockscreen" "$overlay_shell/contents/"
    if [ -d "$system_shell/contents/logout" ] && [ -d "$custom_shell/contents/logout" ]; then
        cp -rL "$custom_shell/contents/logout/." "$overlay_shell/contents/logout/"
    fi

    for base in qmldir config.xml; do
        if [ -f "$system_shell/contents/lockscreen/$base" ] && [ ! -f "$overlay_shell/contents/lockscreen/$base" ]; then
            cp "$system_shell/contents/lockscreen/$base" "$overlay_shell/contents/lockscreen/"
        fi
    done
}
