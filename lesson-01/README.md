# Lab 1 - From source code to a running embedded system

Italian version: [README.it.md](README.it.md).

Checklist for the lab. The slides explain the concepts; this file lists what to do
and what to record. Commands start with `./bin/course` (Windows: `bin\course.cmd`).

Needs: Pico 2 WH, micro-USB data cable, 1 LED, 1 resistor (220 ohm), breadboard,
Docker, a serial terminal.

| | Linux | macOS | Windows |
| --- | --- | --- | --- |
| BOOTSEL drive | `/media/$USER/RP2350` | `/Volumes/RP2350` | new drive letter |
| Serial port | `/dev/ttyACM0` (group `dialout`) | `/dev/cu.usbmodem*` | `COMx`: Device Manager, Ports, "USB Serial Device" (no driver to install) |
| Terminal | `picocom /dev/ttyACM0` | `screen /dev/cu.usbmodem* 115200` | PuTTY / Tera Term, 115200 |

On Windows keep this folder on a Windows drive, not inside WSL.

## Part 0 - Environment

- [ ] Docker is installed and running (`docker --version` works; Windows and macOS: Docker Desktop)
- [ ] Download the course image once (about 1 GB): `docker pull ghcr.io/esd-univr/embedded-iot-course:0.1.0`
- [ ] `./bin/course doctor` ends with `doctor: PASS`
- [ ] Zephyr version: ________  SDK version: ________

## Part 1 - Host and target

- [ ] `./bin/course uname -m` - architecture of the build environment: ________
- [ ] `./bin/course arm-zephyr-eabi-gcc -dumpmachine` - architecture built for: ________
- [ ] Which file sets the LED pin? ________  Which line of `main.c` uses it? ________

## Part 2 - Build and inspect

- [ ] `./bin/course west build -b rpi_pico2/rp2350a/m33/w app`
      (the warning `USBD_CDC_ACM_LOG_LEVEL forced to LOG_LEVEL_NONE` is expected)
- [ ] `build/zephyr/` contains `zephyr.elf`, `.bin`, `.hex`, `.uf2`, `.map`
- [ ] `./bin/course arm-zephyr-eabi-size build/zephyr/zephyr.elf` - flash used (`text` + `data`, not `dec`; the `FLASH:` line of the build output agrees): ________ bytes
- [ ] `./bin/course arm-zephyr-eabi-readelf -h build/zephyr/zephyr.elf` - Machine: ________
- [ ] `./bin/course grep ' main$' build/zephyr/zephyr.map` - address of `main`: ________

## Part 3 - Flash and observe

- [ ] With the USB cable unplugged, wire the LED as in `assets/circuit.svg`: **GP15 = physical pin 20** (not pin 15), GND = pin 18.
      Hold the board with the USB connector at the top: pin 1 is top-left, pin 20 bottom-left
- [ ] Hold BOOTSEL, plug in USB, release: drive `RP2350` appears (Linux: if it is not listed, click it in the file manager to mount it)
      A brand-new board shows the `RP2350` drive on its own the first time. Once it has run a program, the drive appears only if BOOTSEL is held while plugging in: this applies to every later flash
- [ ] Copy `build/zephyr/zephyr.uf2` to the drive with the file manager or `cp`; the drive disappears and the board restarts by itself: this is normal
- [ ] Open the serial port at 115200 (`picocom -b 115200 /dev/ttyACM0`; quit with Ctrl-A Ctrl-X. `screen`: Ctrl-A then K)
- [ ] Lines `toggle N: asked 1000 ms, measured ... us` appear
- [ ] The LED changes state every second. It stays dark for up to 10 s after power-up until a terminal opens the port: wait for it

Nothing on the terminal: check the cable (data, not charge-only), then the port name. Linux says "permission denied": your user must be in group `dialout` (check with `groups`); ask the instructor.
LED dark: check the LED direction (long leg to the resistor) and the pin number.

## Part 4 - Modify

- [ ] In `app/src/main.c` set `BLINK_PERIOD_MS` to `250`
- [ ] Rebuild, enter BOOTSEL (same steps as Part 3), copy the new `zephyr.uf2`
- [ ] LED blinks faster; the log says `asked 250 ms`
- [ ] Change the text of the first `LOG_INF(...)` in `main.c`, rebuild and reflash once more

## Part 5 - Measure

- [ ] Set `BLINK_PERIOD_MS` back to `1000`, rebuild, reflash, then collect 20 `measured` values
- [ ] For each value: error = `measured` - 1000 x `asked` (`asked` is in ms, `measured` in us). Example: asked 1000, measured 1000043 gives 43 us
- [ ] Smallest error: ________ us  Largest error: ________ us
- [ ] One reason why `measured` is not exactly `asked`: ________
- [ ] Optional challenge: estimate the average time of one `gpio_pin_toggle_dt()` call in a loop of 1000 calls (see the hints at the end of the loop in `main.c`), rebuild, reflash
- [ ] Average time of one toggle in that loop: ________ ns (total divided by 1000)
