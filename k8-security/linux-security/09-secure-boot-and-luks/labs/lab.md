# Lab — LUKS Full-Disk Encryption (use a spare/loop device!)
1. `dd if=/dev/zero of=disk.img bs=1M count=200 && losetup /dev/loop9 disk.img`.
2. `examples/luks-setup.sh /dev/loop9`; back up the LUKS header.
3. Close/reopen; prove data is unreadable without the passphrase.
**Deliverable:** encrypted volume + header backup + locked/unlocked demo.
