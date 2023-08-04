@echo off
goto :no

:choice
set /P c=Would you like to wipe emulator data? [Y/N]
if /I "%c%" EQU "Y" goto :yes
if /I "%c%" EQU "N" goto :no
echo Invalid option, please use Y/N
goto :choice

:yes
if exist qemu rmdir /s /q qemu
mkdir qemu
qemu-img create qemu/HDD.img 1M

:no
if exist binaries rmdir /s /q binaries
if exist images rmdir /s /q images
mkdir binaries
mkdir binaries\programs
mkdir images

echo START OF NASM OUTPUT
echo --------------------
echo Kernel
echo --------------------
nasm -O0 -f bin source/mbr.asm -o binaries/mbr.bin
nasm -O0 -f bin source/kernel.asm -o binaries/kernel.bin
echo --------------------
echo Programs
echo --------------------
@echo off
cd source/programs
for %%i in (*.asm) do (
    nasm -O0 -f bin %%i -o ..\..\binaries\programs\%%~ni.bin
)
cd ..\..
echo --------------------
echo END OF NASM OUTPUT

:choice2
set /P c=Would you like to continue? [Y/N]
if /I "%c%" EQU "Y" goto :yes2
if /I "%c%" EQU "N" goto :no2
echo Invalid option, please use Y/N
goto :choice2

:yes2

cd images
dd count=2 seek=0 bs=512 if=..\binaries\mbr.bin of=.\potatos.flp
cd ..

echo Please Wait...
imdisk -a -f images\potatos.flp -s 1440K -m B:

copy binaries\kernel.bin B:\
copy binaries\programs\*.bin B:\


imdisk -D -m B:

:no2