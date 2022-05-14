#!/bin/bash

# shell folder
shell_folder=$(cd "$(dirname "$0")" || exit;pwd)

export PATH="/root/workspace/.toolchains/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/:$PATH"
export PATH="/home/cn1396/.toolchain/gcc-arm-10.3-2021.07-x86_64-arm-none-linux-gnueabihf/bin/:$PATH"
export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-

cmd_help() {
	echo "Basic mode:"
	echo "$0 h			---> Command help"
	echo "$0 qemu		---> Build qemu"
	echo "$0 atf		---> Build arm trusted firmware "
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

	make bl1 ARCH=aarch32 PLAT=a15 CROSS_COMPILE=arm-none-linux-gnueabihf- \
		DEBUG=1

	finish_time=${SECONDS}
	duration=$((finish_time-start_time))
	elapsed_time="$((duration / 60))m $((duration % 60))s"
	echo -e  "ATF used:${elapsed_time}"
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
else
	echo "wrong args."
	cmd_help
	exit
fi
