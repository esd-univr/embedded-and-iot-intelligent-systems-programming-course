# SPDX-License-Identifier: Apache-2.0
cmake_minimum_required(VERSION 3.20.0)

# On the Pico 2 the console is a USB serial port (no extra wiring needed).
# This snippet is applied here so `west build` needs no extra flags.
if(BOARD MATCHES "^rpi_pico2")
  set(SNIPPET cdc-acm-console)
endif()

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(lab01)

target_sources(app PRIVATE src/main.c)
