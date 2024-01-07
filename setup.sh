
# https://medium.com/@daeseok.youn/prepare-the-environment-for-developing-linux-kernel-with-qemu-c55e37ba8ade

function install_tools() {
    sudo apt install build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache flex bison libelf-dev
}

function create_config() {
    make ARCH=x86_64 x86_64_defconfig
    # Open TUI
    make ARCH=x86_64 menuconfig
}
