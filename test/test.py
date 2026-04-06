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

    # Reset with preset value of 10 on ui_in[7:1]
    dut.ena.value = 1
    dut.ui_in.value = 10 << 1  # shift left by 1 since ui_in[0] is start
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test: counter loads preset value from input pins")
    await ClockCycles(dut.clk, 1)

    # done bit should be 0, count loaded from ui_in[7:1] = 10
    assert dut.uo_out.value[7] == 0, "Done should be 0 after reset"

    dut._log.info("Test passed!")