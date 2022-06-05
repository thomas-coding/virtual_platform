#!/bin/bash

# shell folder
shell_folder=$(cd "$(dirname "$0")" || exit;pwd)


#export PATH="/root/workspace/.toolchains/gcc-arm-none-eabi-10-2020-q4-major/bin/:$PATH"
export PATH="/root/workspace/.toolchains/gcc-arm-10.3-2021.07-x86_64-arm-none-eabi/bin/:$PATH"

# gdb
arm-none-eabi-gdb \
-ex 'target remote localhost:1234' \
-ex "add-symbol-file ${shell_folder}/arm-trusted-firmware/build/a15/debug/bl1/bl1.elf" \
-ex "add-symbol-file ${shell_folder}/arm-trusted-firmware/build/a15/debug/bl2/bl2.elf" \
-ex "add-symbol-file ${shell_folder}/arm-trusted-firmware/build/a15/debug/bl32/bl32.elf" \
-ex "add-symbol-file ${shell_folder}/u-boot/u-boot" \
-ex "add-symbol-file ${shell_folder}/linux/vmlinux" \
-ex "add-symbol-file ${shell_folder}/buildroot/output/build/busybox-1.35.0/busybox" \
-ex "restore ${shell_folder}/linux/arch/arm/boot/uImage binary 0x25000000" \
-ex "restore ${shell_folder}/linux/arch/arm/boot/dts/a15.dtb binary 0x26000000" \
-ex "restore ${shell_folder}/buildroot/output/images/rootfs.cpio.uboot binary 0x28000000" \
-q
 