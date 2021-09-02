# Homebrew Tap for QEMU with M1 (Apple Silicon) support

## How do I install this formula?

`brew install slp/qemu-m1/qemu-m1`

Or `brew tap slp/qemu-m1` and then `brew install qemu-m1`.

## Examples

In all these examples, a port forwarding is set up from port `2222` in the host to port `22` in the guest. Once SSH is configued in the guest, including having copied the public keys to it, it should be possible to log into the VM with something like `ssh -p 2222 root@127.0.0.1`.

### Using Fedora's aarch64 raw image (text mode via serial console)

```
curl -OL https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/aarch64/images/Fedora-Server-34-1.2.aarch64.raw.xz
xz -d Fedora-Server-34-1.2.aarch64.raw.xz
qemu-m1 -accel hvf -m 2048 -smp 2 -machine virt,highmem=off -cpu cortex-a57 -L /opt/homebrew/share/qemu -drive file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on -drive file=Fedora-Server-34-1.2.aarch64.raw,format=raw,if=none,id=fedora -device virtio-blk,drive=fedora -vga none -serial telnet::6666,server,wait -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 &
telnet 127.0.0.1 6666
```

### Using Fedora's aarch64 raw image (graphics via ramfb)

```
curl -OL https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/aarch64/images/Fedora-Server-34-1.2.aarch64.raw.xz
xz -d Fedora-Server-34-1.2.aarch64.raw.xz
qemu-m1 -accel hvf -m 2048 -smp 2 -machine virt,highmem=off -cpu cortex-a57 -L /opt/homebrew/share/qemu -drive file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on -drive file=Fedora-Server-34-1.2.aarch64.raw,format=raw,if=none,id=fedora -device virtio-blk,drive=fedora -vga none -device ramfb -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 -device usb-ehci -device usb-kbd -device usb-mouse
```

### Installing Fedora from an ISO (graphics via ramfb)

```
curl -OL https://download.fedoraproject.org/pub/fedora/linux/releases/34/Server/aarch64/iso/Fedora-Server-dvd-aarch64-34-1.2.iso
qemu-img create -f qcow2 fedora34.qcow2 20G
qemu-m1 -accel hvf -m 2048 -smp 2 -machine virt,highmem=off -cpu cortex-a57 -L /opt/homebrew/share/qemu -drive file=/opt/homebrew/share/qemu/edk2-aarch64-code.fd,if=pflash,format=raw,readonly=on -drive file=fedora34.qcow2,format=qcow2,if=none,id=fedora -device virtio-blk,drive=fedora -cdrom Fedora-Server-dvd-aarch64-34-1.2.iso -vga none -device ramfb -net nic,model=virtio -net user,hostfwd=tcp::2222-:22 -device usb-ehci -device usb-kbd -device usb-mouse
```
