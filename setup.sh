
# https://medium.com/@daeseok.youn/prepare-the-environment-for-developing-linux-kernel-with-qemu-c55e37ba8ade

function install_tools() {
    sudo apt install build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache flex bison libelf-dev
}

function create_config() {
    make ARCH=x86_64 x86_64_defconfig
    # Open TUI
    make ARCH=x86_64 menuconfig
}

function compile() {
    make -j$(nproc)

    git clone git://git.buildroot.net/buildroot
    cd buildroot
    # Invoke menu-config and create ext2/3/4 root filesystem 
    # Also set target architecture to x86
    # cp output/images/rootfs.ext2 ../
    # ============

    # Generate compile commands.json
    ./scripts/clangd-tools/gen_compile_commands.py
}

function qemu_run() {
    # Qemu listens tcp::1234 (-s)
    # Qemu suspend execution until gdb connects (-S) 
    # buildroot username = root
    qemu-system-x86_64 \
        -s -S \
        -kernel arch/x86/boot/bzImage \
        -boot c \
        -m 2049M \
        -hda rootfs.ext4 \
        -append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" \
        -serial stdio \
        -display none
}

function debug_gdb() {
    gdb ./vmlinux 
    #target remote localhost:1234
    #break start_kernel
}