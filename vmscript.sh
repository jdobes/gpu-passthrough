#!/usr/bin/bash

vmname="windows10vm"

if ps -A | grep -q $vmname; then
echo "$vmname is already running." &
exit 1

else

# use pulseaudio
export QEMU_AUDIO_DRV=pa
export QEMU_PA_SAMPLES=1024
export QEMU_AUDIO_TIMER_PERIOD=99
export QEMU_PA_SERVER=/run/user/1000/pulse/native

cp /usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd /tmp/my_vars.fd

qemu-system-x86_64 \
-name $vmname,process=$vmname \
-machine type=q35,accel=kvm \
-cpu host,kvm=off \
-smp 8,sockets=1,cores=4,threads=2 \
-m 4G \
-balloon none \
-rtc clock=host,base=localtime \
-vga none \
-nographic \
-serial none \
-parallel none \
-soundhw hda \
-usb -device usb-host,hostbus=1,hostaddr=5 \
-device usb-host,hostbus=1,hostaddr=4 \
-device vfio-pci,host=01:00.0,multifunction=on \
-device vfio-pci,host=01:00.1 \
-drive if=pflash,format=raw,readonly,file=/usr/share/edk2.git/ovmf-x64/OVMF_CODE-pure-efi.fd \
-drive if=pflash,format=raw,file=/tmp/my_vars.fd \
-boot order=dc \
-drive id=disk0,if=virtio,cache=none,format=raw,file=/home/jan/libvirt-images/windows10vm.img \
#-drive file=/home/jan/libvirt-images/Win10_1709_Czech_x64.iso,media=cdrom \
#-drive file=/home/jan/libvirt-images/virtio-win-0.1.141_amd64.vfd,if=floppy \
#-net bridge,br=virbr0 -net nic,model=virtio
#-netdev type=tap,id=net0,ifname=vmtap0,vhost=on \
#-device virtio-net-pci,netdev=net0,mac=00:16:3e:00:01:01

exit 0
fi
