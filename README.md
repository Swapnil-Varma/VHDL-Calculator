# Basys 3 VHDL Calculator — Switch / Button / LED Version

No external keypad is required.

## Hardware interface

- SW15..SW8 = Operand A (8-bit unsigned)
- SW7..SW0 = Operand B (8-bit unsigned)
- BTNU = Addition
- BTND = Subtraction
- BTNL = Multiplication
- BTNR = Division
- BTNC = Clear/reset
- LED15..LED0 = 16-bit result in binary
- Basys 3 4-digit seven-segment display = decimal result

The onboard 100 MHz clock is used.

## Examples

A = 25 = 00011001
B = 13 = 00001101

Press BTNU:
25 + 13 = 38
LEDs show binary 38 = 0000_0000_0010_0110
7-segment shows 0038

Press BTNL:
25 * 13 = 325
LEDs show 0000_0001_0100_0101
7-segment shows 0325

Division is integer division:
25 / 13 = 1

For A < B subtraction, the result is represented as a signed 16-bit two's-complement value on LEDs and the seven-segment display shows a minus sign followed by the magnitude.

Divide by zero shows Err on the seven-segment display and clears the binary result to 0.

## Vivado
1. Create an RTL project for `xc7a35tcpg236-1`.
2. Add all VHDL files from `src/`.
3. Add `constraints/basys3_calculator_switch_led.xdc`.
4. Set `calculator_top.vhd` as top.
5. Add `tb/tb_calculator_core.vhd` as a simulation source.
6. Run behavioral simulation.
7. Run synthesis and implementation.
8. Generate bitstream.
9. Program the Basys 3.

The XDC uses the official Basys 3 Rev. C pin mapping.
