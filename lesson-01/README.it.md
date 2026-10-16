# Lab 1 - Dal codice sorgente a un sistema embedded in esecuzione

English version: [README.md](README.md).

Checklist per il laboratorio. Le slide spiegano i concetti; questo file elenca cosa fare
e cosa annotare. I comandi iniziano con `./bin/course` (Windows: `bin\course.cmd`).

Occorrono: Pico 2 WH, cavo micro-USB per dati, 1 LED, 1 resistenza (220 ohm), breadboard,
Docker, un terminale seriale.

| | Linux | macOS | Windows |
| --- | --- | --- | --- |
| Unità BOOTSEL | `/media/$USER/RP2350` | `/Volumes/RP2350` | nuova lettera di unità |
| Porta seriale | `/dev/ttyACM0` (gruppo `dialout`) | `/dev/cu.usbmodem*` | `COMx`: Gestione dispositivi, Porte, "USB Serial Device" (nessun driver da installare) |
| Terminale | `picocom /dev/ttyACM0` | `screen /dev/cu.usbmodem* 115200` | PuTTY / Tera Term, 115200 |

Su Windows tenere questa cartella su un disco Windows, non dentro una distribuzione WSL (WSL 2 deve comunque essere installato per Docker Desktop).

## Parte 0 - Ambiente

- [ ] Docker è installato e in esecuzione (`docker --version` funziona; Windows e macOS: Docker Desktop; su Windows serve anche WSL 2: `wsl --install` in un PowerShell da amministratore, poi riavviare)
- [ ] Scaricare una volta l'immagine del corso (circa 1 GB): `docker pull ghcr.io/esd-univr/embedded-iot-course:0.1.0`
- [ ] `./bin/course doctor` termina con `doctor: PASS`
- [ ] Versione di Zephyr: ________  Versione dell'SDK: ________

## Parte 1 - Host e target

- [ ] `./bin/course uname -m` - architettura dell'ambiente di build: ________
- [ ] `./bin/course arm-zephyr-eabi-gcc -dumpmachine` - architettura per cui si compila: ________
- [ ] Quale file definisce il pin del LED? ________  Quale riga di `main.c` lo usa? ________

## Parte 2 - Build e ispezione

- [ ] `./bin/course west build -b rpi_pico2/rp2350a/m33/w app`
      (l'avviso `USBD_CDC_ACM_LOG_LEVEL forced to LOG_LEVEL_NONE` è atteso)
- [ ] `build/zephyr/` contiene `zephyr.elf`, `.bin`, `.hex`, `.uf2`, `.map`
- [ ] `./bin/course arm-zephyr-eabi-size build/zephyr/zephyr.elf` - flash usata (`text` + `data`, non `dec`; la riga `FLASH:` dell'output della build coincide): ________ byte
- [ ] `./bin/course arm-zephyr-eabi-readelf -h build/zephyr/zephyr.elf` - Machine: ________
- [ ] `./bin/course grep ' main$' build/zephyr/zephyr.map` - indirizzo di `main`: ________

## Parte 3 - Flash e osservazione

- [ ] Con il cavo USB scollegato, cablare il LED come in `assets/circuit.svg`: **GP15 = pin fisico 20** (non il pin 15), GND = pin 18.
      Tenere la scheda con il connettore USB in alto: il pin 1 è in alto a sinistra, il pin 20 in basso a sinistra
- [ ] Tenere premuto BOOTSEL, collegare l'USB, rilasciare: appare l'unità `RP2350` (Linux: se non è elencata, cliccarla nel file manager per montarla)
      Una scheda nuova mostra l'unità `RP2350` da sola la prima volta. Dopo che ha eseguito un programma, l'unità appare solo se BOOTSEL è premuto durante il collegamento: vale per ogni flash successivo
- [ ] Copiare `build/zephyr/zephyr.uf2` sull'unità con il file manager o con `cp`; l'unità scompare e la scheda si riavvia da sola: è normale
- [ ] Aprire la porta seriale a 115200 (`picocom -b 115200 /dev/ttyACM0`; uscire con Ctrl-A Ctrl-X. `screen`: Ctrl-A poi K)
- [ ] Compaiono righe `toggle N: asked 1000 ms, measured ... us`
- [ ] Il LED cambia stato ogni secondo. Resta spento fino a 10 s dopo l'accensione finché un terminale non apre la porta: aspettare

Niente sul terminale: controllare il cavo (per dati, non solo ricarica), poi il nome della porta. Linux dice "permission denied": l'utente deve essere nel gruppo `dialout` (verificare con `groups`); chiedere al docente.
LED spento: controllare il verso del LED (gamba lunga verso la resistenza) e il numero del pin.

## Parte 4 - Modifica

- [ ] In `app/src/main.c` impostare `BLINK_PERIOD_MS` a `250`
- [ ] Ricompilare, entrare in BOOTSEL (stessi passi della Parte 3), copiare il nuovo `zephyr.uf2`
- [ ] Il LED lampeggia più veloce; il log dice `asked 250 ms`
- [ ] Cambiare il testo del primo `LOG_INF(...)` in `main.c`, ricompilare e riscrivere in flash ancora una volta

## Parte 5 - Misura

- [ ] Riportare `BLINK_PERIOD_MS` a `1000`, ricompilare, riscrivere in flash, poi raccogliere 20 valori di `measured`
- [ ] Per ogni valore: errore = `measured` - 1000 x `asked` (`asked` è in ms, `measured` in us). Esempio: asked 1000, measured 1000043 dà 43 us
- [ ] Errore minimo: ________ us  Errore massimo: ________ us
- [ ] Un motivo per cui `measured` non è esattamente `asked`: ________
- [ ] Sfida opzionale: stimare il tempo medio di una chiamata a `gpio_pin_toggle_dt()` in un ciclo di 1000 chiamate (vedere i suggerimenti a fine ciclo in `main.c`), ricompilare, riscrivere in flash
- [ ] Tempo medio di un toggle in quel ciclo: ________ ns (totale diviso 1000)
