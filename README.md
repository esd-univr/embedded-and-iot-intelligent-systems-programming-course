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

Then follow `lesson-01/README.md`.

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
