# PotatOS

An Operating System completely in real mode and x86 assembly

# Memory layout

0x00000-0x0FFFF : Stack
0x10000-0x13FFF : Kernel
0x14000-0x147FF : AUTOEXEC
0x14800-0x15FFF : Exit Address (Place kernel goes after programs exit)
0x16000-0x17FFF : Disk Buffer