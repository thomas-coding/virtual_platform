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
-q
 