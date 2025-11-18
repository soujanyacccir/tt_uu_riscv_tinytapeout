# Tiny RISC-V (1x1)

Ultra-small RISC-V-like core optimized to fit a single TinyTapeout tile.

## Summary
- Single-cycle, RV-like instruction subset: ADDI, ADD, SUB, BEQ, LUI.
- 8 registers (r0..r7), r0 is zero.
- 16-word ROM containing a demo loop that increments r1.
- GPIO in (ui_in[7:0]) and GPIO out (uo_out[7:0]).
- NOT a full RV32I implementation: simplified to reduce area.
