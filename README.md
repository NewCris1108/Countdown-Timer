# Countdown Timer — TinyTapeout SKY26a

![gds](https://github.com/NewCris1108/Countdown-Timer/actions/workflows/gds.yaml/badge.svg)
![docs](https://github.com/NewCris1108/Countdown-Timer/actions/workflows/docs.yaml/badge.svg)
![test](https://github.com/NewCris1108/Countdown-Timer/actions/workflows/test.yaml/badge.svg)

An 8-bit countdown timer designed in Verilog and submitted to the TinyTapeout SKY26a multi-project wafer shuttle (silicon expected December 2026).

## How it works
Set a countdown value using the 7 input pins, press start, and watch the 7-segment display count down to zero. When done, an output signal goes high.

## Design
- 25-bit clock divider (50 MHz → ~1 Hz)
- 8-bit synchronous down counter
- 7-segment BCD decoder
- 3-state FSM: IDLE → RUN → DONE

## Author
Cris Zapata — github.com/NewCris1108