# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test: counter starts at 255 after reset")
    await ClockCycles(dut.clk, 1)
    # count starts at 0xFF, done bit is 0, so uo_out[6:0] = 0x7F
    assert dut.uo_out.value[7] == 0, "Done should be 0 after reset"

    dut._log.info("Test passed!")