# 🧠 Day 2 – Booting Into Chaos (and Surviving It)

## 🌑 Summary
This day felt like opening a cursed grimoire written in assembly. Got my kernel connected, the floppy image built, and ran it in QEMU. But the bugs? Oh, the bugs.

## ⚙️ What I did
- Assembled `boot.asm` and `kernel.asm` using NASM
- Created a Makefile to automate everything
- Used `dd` to make a floppy image
- Ran the image on QEMU
- Started basic input: keyboard and mouse (setup stage)

## 🧪 Tools I used
- NASM
- QEMU
- `dd`
- `make`
- Terminal (my second home)

## 🐛 Errors I faced (a.k.a. The Bug Parade)
- **Permission denied** when running `make` — forgot executable perms
- **Nothing showed up after QEMU launch** — panic. Turns out I didn’t link kernel properly
- **QEMU trapped me in the void** — had no idea how to exit. It just... stayed there mocking me 😵
- **Wrong file output** — accidentally output kernel to `.bin` instead of `.o`, linker said "nah"
- **"Nothing to commit" Git confusion** — turns out I had to `git push` 🤦‍♂️

## 💭 Mental state
- Brain was overheating like an old ThinkPad
- Frustration meter: 🔥🔥🔥🔥
- But also... it felt **epic** seeing my own OS *actually booting*, even if it just stared back silently

## 🧠 Lessons learned
- Don’t skip permissions. They’ll haunt you.
- QEMU exits with `Ctrl + A` then `X` (after 17 minutes of button smashing).
- A good Makefile = a happy brain.
- When in doubt, `make clean`.

## 🗂️ Files I worked on
- `src/bootloader/boot.asm`
- `src/kernel/kernel.asm`
- `Makefile`
- `build/main_floppy.img`

---

## 🔮 Next Up (Day 3 Plan)
- Add actual screen output
- Start handling keyboard input (maybe detect keypresses)
- If brave enough, mouse input 👀
- Begin writing memory map & interrupt handling

---

**ObscuraOS is slowly waking up.** And it's looking right back at me.
