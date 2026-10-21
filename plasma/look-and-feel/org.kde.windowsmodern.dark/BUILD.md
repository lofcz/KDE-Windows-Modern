# Build Instructions: Windows Modern Boot Greeter (Plasma Login Manager)

The boot greeter is a **patched build of [plasma-login-manager](https://invent.kde.org/plasma/plasma-login-manager)**
(vendored as a git submodule at `third_party/plasma-login-manager/`, branch
`Plasma/6.8`). A single patch (`patches/main-cpp.patch`) redirects the
greeter to load our `Main.qml` from the dark look-and-feel's
`contents/lockscreen/` instead of the bundled qrc resource.

Because it is a compiled C++ binary that replaces the system login
manager, it must be built during installation.

## Prerequisites

A C++ compiler, CMake, and the Qt6/KF6/Plasma development headers. The
PLM dependency set differs slightly from the System Tray / Icon Tasks
applets — it adds **Qt6 ShaderTools**, **LayerShellQt**, **libkscreen**,
and **PAM**.

### Install build dependencies

**Fedora:**

```bash
sudo dnf install gcc-c++ cmake extra-cmake-modules pkgconf-pkg-config \
  qt6-qtbase-devel qt6-qtdeclarative-devel qt6-qttools-devel \
  qt6-qtshadertools-devel \
  kf6-kconfig-devel kf6-kpackage-devel kf6-kwindowsystem-devel \
  kf6-ki18n-devel kf6-kdbusaddons-devel kf6-kcmutils-devel \
  kf6-kauth-devel kf6-kio-devel \
  libplasma-devel plasma-workspace-devel \
  layer-shell-qt-devel libkscreen-devel \
  pam-devel
```

**Arch Linux:**

```bash
sudo pacman -S cmake extra-cmake-modules pkgconf \
  qt6-base qt6-declarative qt6-tools qt6-shadertools \
  kconfig kpackage kwindowsystem ki18n kdbusaddons kcmutils kauth kio \
  libplasma plasma-workspace \
  layer-shell-qt libkscreen pam
```

**Debian/Ubuntu:**

```bash
sudo apt install cmake extra-cmake-modules pkg-config \
  qt6-base-dev qt6-declarative-dev qt6-tools-dev \
  qt6-shadertools-dev qt6-quickcontrols2-dev \
  libkf6config-dev libkf6package-dev libkf6windowsystem-dev \
  libkf6i18n-dev libkf6dbusaddons-dev libkf6kcmutils-dev \
  libkf6auth-dev libkf6kio-dev \
  libplasma-dev plasma-workspace-dev \
  layer-shell-qt-dev libkscreen-dev \
  libpam0g-dev
```

> The two packages most likely missing if you already build the System
> Tray / Icon Tasks applets are **`qt6-qtshadertools-devel`** (Fedora) /
> `qt6-shadertools` (Arch) / `qt6-shadertools-dev` (Debian) and
> **`layer-shell-qt-devel`** (Fedora) / `layer-shell-qt` (Arch).

## Build and test (user, no system changes)

```bash
./install.sh greeter
```

This applies the patch, builds `plasma-login-greeter` into
`third_party/plasma-login-manager/build-user/`, reverts the patch to keep
the submodule clean, and installs the theme QML to
`~/.local/share/plasma/look-and-feel/org.kde.windowsmodern.dark/contents/lockscreen/`.

Test in a window without touching the system login manager:

```bash
third_party/plasma-login-manager/build-user/bin/plasma-login-greeter --test
```

## Install as the real boot greeter (system-wide, needs root)

```bash
sudo bash scripts/install-greeter-live.sh
```

The installer detects `/usr/lib/plasma-login-greeter` on Arch/CachyOS and
`/usr/libexec/plasma-login-greeter` on distributions that use libexec. It
backs up the current binary and atomically replaces it, then installs the
theme and wallpaper system-wide. It does not stop or restart the display
manager and does not sign out the current user.

The new greeter is used when the login manager next launches a greeter.
KWin itself switches to the installed release on your next login or reboot;
the installer never restarts a running Wayland compositor.

The patched greeter falls back to the built-in login screen if the custom
QML cannot load. `WINDOWS_MODERN_GREETER_THEME=/path/to/Main.qml` selects a
theme only in `--test` mode; live logins only load the system-installed theme.

## Revert

Restore the backup printed by the installer with an atomic replacement:

```bash
sudo install -m 755 /path/to/backup /usr/lib/plasma-login-greeter.restore
sudo mv -Tf /usr/lib/plasma-login-greeter.restore /usr/lib/plasma-login-greeter
```

Use `/usr/libexec` instead on distributions that install the greeter there.
No display-manager restart is required to restore the next-login binary.

Remove the user theme + revert any applied patches:

```bash
./uninstall.sh greeter
```

## Update the PLM submodule

To track a newer upstream release (e.g. a Plasma 6.8 point release):

```bash
./scripts/update-plm.sh Plasma/6.8
```

This fetches the new branch, reapplies `main-cpp.patch`, and rebuilds.
If the patch no longer applies cleanly, edit
`plasma/look-and-feel/org.kde.windowsmodern.dark/patches/main-cpp.patch`
against the new `src/frontend/greeter/main.cpp`.

## Notes

- The greeter QML lives in the **dark** look-and-feel package only
  (`org.kde.windowsmodern.dark/contents/lockscreen/`). PLM runs before
  any user session, so there is no light/dark variant switch — the dark
  greeter is used regardless of the user's preferred scheme.
- The greeter wallpaper defaults to the Windows Modern dark wallpaper at
  `/usr/share/wallpapers/Windows-modern/contents/images_dark/2560x1440.png`.
  `install-greeter-live.sh` ensures it is installed system-wide. In
  `--test` mode with no system install, the background renders black
  (the overlay rectangle), which is expected.
