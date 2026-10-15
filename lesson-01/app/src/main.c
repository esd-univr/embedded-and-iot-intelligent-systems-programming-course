/*
 * Lab 1 - From source code to a running embedded system.
 *
 * Toggles an LED, logs every toggle on the console and measures how long
 * each sleep really took.
 */
#include <zephyr/kernel.h>
#include <zephyr/device.h>
#include <zephyr/drivers/gpio.h>
#include <zephyr/drivers/uart.h>
#include <zephyr/logging/log.h>

LOG_MODULE_REGISTER(lab01, LOG_LEVEL_INF);

/* Part 4: change how fast the LED blinks. */
#define BLINK_PERIOD_MS 1000

/* The LED is chosen by the devicetree alias "led0" (see the boards/ directory). */
static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(DT_ALIAS(led0), gpios);

/*
 * With a USB console, anything printed before the host opens the serial port
 * is lost. Wait (at most 10 s) for the terminal so the first lines are seen.
 * On boards with a plain UART console this does nothing.
 */
static void wait_for_terminal(void)
{
#if DT_NODE_HAS_COMPAT(DT_CHOSEN(zephyr_console), zephyr_cdc_acm_uart)
	const struct device *console = DEVICE_DT_GET(DT_CHOSEN(zephyr_console));
	uint32_t dtr = 0;

	for (int i = 0; i < 100 && !dtr; i++) {
		uart_line_ctrl_get(console, UART_LINE_CTRL_DTR, &dtr);
		k_msleep(100);
	}
#endif
}

int main(void)
{
	wait_for_terminal();

	LOG_INF("Lab 1 on %s, blink period %d ms", CONFIG_BOARD_TARGET, BLINK_PERIOD_MS);

	if (!gpio_is_ready_dt(&led) ||
	    gpio_pin_configure_dt(&led, GPIO_OUTPUT_INACTIVE) < 0) {
		LOG_ERR("LED not available");
		return 0;
	}

	for (uint32_t n = 0;; n++) {
		/* Part 5: time the sleep with the hardware cycle counter. */
		uint32_t start = k_cycle_get_32();

		gpio_pin_toggle_dt(&led);
		k_msleep(BLINK_PERIOD_MS);

		uint32_t elapsed_us = k_cyc_to_us_near32(k_cycle_get_32() - start);

		LOG_INF("toggle %u: asked %d ms, measured %u us", n, BLINK_PERIOD_MS, elapsed_us);

		/*
		 * Part 5 (challenge): measure how long 1000 consecutive calls to
		 * gpio_pin_toggle_dt() take, and print the average per call in ns.
		 * Hint: same pattern as above, with a for loop instead of
		 * k_msleep(), and k_cyc_to_ns_near32() instead of
		 * k_cyc_to_us_near32(). Print with LOG_INF(). Doing it on every
		 * iteration is fine, but it delays the blink.
		 */
	}

	return 0;
}
