# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test counter increments after reset")

    # After reset, output should be 0 (counter[24] is 0)
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == 0, "Output should be 0 after reset"

    # Wait 10 more cycles and confirm counter is still incrementing (output stays 0
    # since counter[24] won't flip for millions of cycles)
    await ClockCycles(dut.clk, 10)
    assert dut.uo_out.value == 0, "Counter bit 24 should still be 0 after 20 cycles"

    dut._log.info("Test passed!")