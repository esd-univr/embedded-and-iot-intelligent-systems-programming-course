# Embedded and IoT Intelligent Systems Programming

Public student workspace for the **Embedded and IoT Intelligent Systems Programming** course.

Released lesson material is published progressively in this repository. Each
`lesson-XX/` directory contains the material intended for students: the lab
handout, starter code, supporting assets, course launchers, and released slide
decks.

## Getting the course material

Clone this repository:

```bash
git clone https://github.com/esd-univr/embedded-and-iot-intelligent-systems-programming-course.git
cd embedded-and-iot-intelligent-systems-programming-course
```

For Lesson 01:

```bash
cd lesson-01
```

Then follow `lesson-01/README.md` (Italian: `lesson-01/README.it.md`). The slides are in
`lesson-01/slides/` in English and Italian.

## Course container image

The lessons build inside a course container image that contains the compiler,
Zephyr and every tool at a fixed version, so every computer builds the same way.
Nothing else needs to be installed except Docker.

| | |
| --- | --- |
| Image | `ghcr.io/esd-univr/embedded-iot-course:0.1.0` |
| Download | about 1 GB, once |
| Disk space | about 4.5 GB after download |
| Requires | Docker Desktop (Windows, macOS) or Docker Engine (Linux), running |

Download it once, ideally on the university network:

```bash
docker pull ghcr.io/esd-univr/embedded-iot-course:0.1.0
```

Check that it works (on Windows use `lesson-01\bin\course.cmd doctor`):

```bash
lesson-01/bin/course doctor
```

The last line must be `doctor: PASS`. If the download fails, or you have no
Docker, tell the instructor: an offline copy of the image can be loaded with
`docker load -i <file>.tar.gz`.

### Windows

1. Install WSL 2 first: open PowerShell **as administrator**, run `wsl --install`
   and restart the computer. Docker Desktop needs it to run its Linux engine, even
   if you never use WSL yourself; without it Docker fails with an error mentioning
   `dockerDesktopLinuxEngine`. Then install Docker Desktop, start it, and wait until
   it reports that the engine is running.
2. Keep this repository on a normal Windows drive (for example
   `C:\Users\<you>\...`), not inside a WSL distribution, and open **PowerShell**
   in it. USB devices are not shared with WSL.
3. `docker pull ghcr.io/esd-univr/embedded-iot-course:0.1.0`
4. `lesson-01\bin\course.cmd doctor` must end with `doctor: PASS`. The same
   launcher runs the other lesson commands: replace `./bin/course` with
   `bin\course.cmd` (from `lesson-01`).
5. The board needs no driver. In BOOTSEL mode it appears as a new drive (for
   example `D:`, label `RP2350`): copy `build\zephyr\zephyr.uf2` to it with File
   Explorer or `Copy-Item build\zephyr\zephyr.uf2 D:\`. After the restart the
   serial port appears in Device Manager, under Ports, as "USB Serial Device
   (COMx)". It is not listed as Raspberry Pi. Open it at 115200 with PuTTY or Tera
   Term.

In GitHub Codespaces the repository opens inside this image automatically
(`.devcontainer/`). A Codespace can build the lab, but flashing the board and the
serial terminal still happen on your own computer, so you must download the
`.uf2` file from the Codespace to copy it onto the board.

## Repository structure

```text
lesson-01/
  README.md        Lab handout and checklist
  app/             Starter Zephyr application
  assets/          Figures and wiring material
  bin/             Course container launchers and version pins
  slides/          Released lecture slides
```

Only released student material is published here. Instructor notes, reference
solutions, and qualification material are not part of this repository.

## Getting updates

If you already cloned the repository, update it from its root:

```bash
git pull --ff-only
```

New lessons and updated course material will appear in the same checkout.
