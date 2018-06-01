# SAMD21G18A_delay
In this example a delay don't make an empty job, but passing handle into a main cycle. You can watch it in oscilloscope data jpg file. Yellow line is LED_BLINK result, but green one is TEST_PIN_BLINK result. The TEST_PIN_BLINK makes 4 cycles (8 blinks), and on the start of third cycle pulling up a flag to mark the LED_BLINK to run.

ARM compiler is needed.
