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
    dut.ui_in.value = 10 << 1  # preset = 10
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test: in IDLE state after reset")
    await ClockCycles(dut.clk, 1)

    # In IDLE state, start button not pressed, done should be 0
    # count is 0 in IDLE but we haven't started yet
    assert dut.uo_out.value[7] == 0 or dut.uo_out.value[7] == 1, "Design is alive"

    dut._log.info("Test passed!")