## How it works

This is an 8-bit countdown timer. Set the start value using the 7 input pins (ui[1] through ui[7]), then press the start button (ui[0]) to begin counting down. The current count is displayed on a 7-segment display connected to uo[0] through uo[6]. When the count reaches zero, the done signal (uo[7]) goes high.

The design uses a clock divider to slow the 50 MHz system clock down to approximately 1 Hz, so the counter decrements once per second.

## How to test

1. Set ui[1] through ui[7] to a binary value (e.g. 00001010 for 10 seconds)
2. Press ui[0] (start button) to begin the countdown
3. Watch the 7-segment display count down to zero
4. When done, uo[7] goes high — connect an LED or buzzer to see it trigger

## External hardware

- 7-segment display connected to uo[0] through uo[6]
- Optional: LED or buzzer on uo[7] for the done signal
- DIP switches on ui[0] through ui[7] for input