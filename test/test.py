import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_tiny_riscv(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units="ns").start())
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    # wait several cycles to see counter increment
    await ClockCycles(dut.clk, 200)

   dut._log.info(f"uo_out = {dut.uo_out.value.binstr}")

