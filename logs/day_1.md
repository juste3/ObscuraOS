# Day 1 - Hello World Bootloader

## 🧠 What I Tried
- Wrote a basic bootloader using NASM
- Used BIOS interrupt 0x10 to print "Hello World"
- Created a 1.44MB floppy image and tested it using QEMU

## 🔍 Bugs & Struggles
- NASM path error → fixed with correct relative path
- QEMU gave format warnings → solved using `truncate`

## 📸 Screenshot
![booted image](../screenshots/booted_os_day1.png)

## ✅ Lessons Learned
- BIOS uses `int 0x10` for printing
- Boot sector = exactly 512 bytes + 0xAA55 magic
- Need Makefile to automate NASM + floppy steps

## 🎯 Next Steps
- Add keyboard input (BIOS int 0x16)
- Log scancodes to screen or memory
