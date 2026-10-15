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

Lesson 01 uses the course container image `embedded-iot-course:0.1.0`.
The image is distributed separately through the course/laboratory environment;
the repository contains the launchers used to run the lesson commands.

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
