#!/bin/bash

# Shell folder
shell_folder=$(cd "$(dirname "$0")" || exit;pwd)

export PATH="/root/workspace/software/qemu/qemu-6.0.0/build/:$PATH"

qemu_option=
if [[ $1  = "--gdb" ]]; then
    qemu_option+=" -s -S"
    echo "enable gdb, please run script './rungdb', and enter c "
else
    echo "not use gdb, just run"
fi

qemu_option+=" -machine thomas-a15 -m 256"
qemu_option+=" -kernel ${shell_folder}/arm-trusted-firmware/build/a15/debug/bl1/bl1.elf"
qemu_option+=" -serial stdio"
qemu_option+=" -device loader,file=${shell_folder}/arm-trusted-firmware/build/a15/debug/bl2.bin,addr=0x00100000"
qemu_option+=" -device loader,file=${shell_folder}/arm-trusted-firmware/build/a15/debug/bl32.bin,addr=0x00200000"
qemu_option+=" -device loader,file=${shell_folder}/u-boot/u-boot.bin,addr=0x20000000"
#qemu_option+=" -device loader,file=${shell_folder}/linux/arch/arm/boot/uImage,addr=0x25000000"
#qemu_option+=" -device loader,file=${shell_folder}/linux/arch/arm/boot/dts/a15.dtb,addr=0x26000000"
qemu_option+=" -d guest_errors"
# Run qemu
#qemu/build/arm-softmmu/qemu-system-arm ${qemu_option}

# Change to develop qemu
#gdb --args qemu/build/arm-softmmu/qemu-system-arm -d in_asm,out_asm,cpu ${qemu_option}

gdb --args qemu/build/arm-softmmu/qemu-system-arm ${qemu_option}
