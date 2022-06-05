#!/bin/bash

# shell folder
shell_folder=$(cd "$(dirname "$0")" || exit;pwd)

# For toolchain
export PATH="/root/workspace/.toolchains/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/:$PATH"
export PATH="/home/cn1396/.toolchain/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/:$PATH"

# For mkimage tool make uImage
export PATH="/root/workspace/code/virtual_platform/u-boot/tools:$PATH"

# For cross compile
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-

cmd_help() {
	echo "Basic mode:"
	echo "$0 h			---> Command help"
	echo "$0 qemu		---> Build qemu"
	echo "$0 u-boot		---> Build u-boot"
	echo "$0 linux		---> Build linux"
	echo "$0 atf		---> Build arm trusted firmware "
	echo "$0 rootfs		---> Build rootfs "
	echo "$0 all		---> Build all "
}

build_qemu() {
	echo "Build qemu ..."
	start_time=${SECONDS}

	cd ${shell_folder}/qemu
	./configure --target-list=arm-softmmu --enable-debug
	make

	finish_time=${SECONDS}
	duration=$((finish_time-start_time))
	elapsed_time="$((duration / 60))m $((duration % 60))s"
	echo -e  "Qemu used:${elapsed_time}"
	exit	
}

build_atf() {
	echo "Build atf ..."
	start_time=${SECONDS}

	cd ${shell_folder}/arm-trusted-firmware
	rm -rf build

	make bl1 bl2 bl32 ARCH=aarch32 AARCH32_SP=sp_min PLAT=a15 CROSS_COMPILE=arm-none-linux-gnueabihf- \
		DEBUG=1

	finish_time=${SECONDS}
	duration=$((finish_time-start_time))
	elapsed_time="$((duration / 60))m $((duration % 60))s"
	echo -e  "ATF used:${elapsed_time}"
	exit	
}

build_u-boot() {
	echo "Build u-boot ..."
	start_time=${SECONDS}

	cd ${shell_folder}/u-boot
	make clean
	make a15_defconfig
	make
	rm -f u-boot.asm
	${CROSS_COMPILE}objdump -xd u-boot > u-boot.asm

	finish_time=${SECONDS}
	duration=$((finish_time-start_time))
	elapsed_time="$((duration / 60))m $((duration % 60))s"
	echo -e  "u-boot used:${elapsed_time}"
	exit	
}

build_linux() {
	echo "Build linux ..."
	start_time=${SECONDS}
	# used for make uImage
	export LOADADDR=0x21008000
	cd ${shell_folder}/linux
	make a15_defconfig
	make
	make -j2 uImage
	rm -f vmlinux.asm
	${CROSS_COMPILE}objdump -xd vmlinux > vmlinux.asm
	${CROSS_COMPILE}objdump -xd arch/arm/boot/compressed/vmlinux > arch/arm/boot/compressed/vmlinux.asm

	finish_time=${SECONDS}
	duration=$((finish_time-start_time))
	elapsed_time="$((duration / 60))m $((duration % 60))s"
	echo -e  "linux used:${elapsed_time}"
	exit
}

build_rootfs() {
	echo "Build rootfs ..."
	start_time=${SECONDS}

	cd ${shell_folder}/buildroot
	make a15_defconfig
	make
	rm -f output/images/rootfs.cpio.uboot
	mkimage -A arm -O linux -T ramdisk -C none -a 0x2c000000 -n "ramdisk" -d  output/images/rootfs.cpio output/images/rootfs.cpio.uboot

	finish_time=${SECONDS}
	duration=$((finish_time-start_time))
	elapsed_time="$((duration / 60))m $((duration % 60))s"
	echo -e  "rootfs used:${elapsed_time}"
	exit
}

if [[ $1  = "h" ]]; then
	cmd_help
	exit
elif [[ $1  = "qemu" ]]; then
	build_qemu
	exit
elif [[ $1  = "atf" ]]; then
	build_atf
	exit
elif [[ $1  = "u-boot" ]]; then
	build_u-boot
	exit
elif [[ $1  = "linux" ]]; then
	build_linux
	exit
elif [[ $1  = "rootfs" ]]; then
	build_rootfs
	exit
elif [[ $1  = "all" ]]; then
	build_qemu
	build_atf
	build_u-boot
	build_linux
	build_rootfs
	exit
else
	echo "wrong args."
	cmd_help
	exit
fi
