# Butterworth Filters — Python & FPGA (VHDL)

Digital **low-pass** and **band-pass** Butterworth filters, first designed and analyzed in Python, then implemented in fixed-point VHDL for an Artix-7 FPGA with an XADC input.

## Overview

- **Low-pass:** third-order Butterworth, **5 kHz** cutoff.
- **Band-pass:** Butterworth design over **9–11 kHz**.
- **Sampling:** **1 MHz** in the Python reference.
- **Fixed-point VHDL:** 12-bit ADC samples, 40-bit signed internal signals with **28 fractional bits**.
- **FPGA target:** `xc7a100tcsg324-1` (Vivado 2025.1 project).

## Project structure

```text
python/
  main.py                 # Low-pass and band-pass design / analysis
  lowpass_reference.py    # Additional low-pass Python study
  bode_passebas.py
  bode_passebande.py
  plots/                  # Saved frequency-response and simulation figures
fpga/
  rtl/                    # IIR filters, XADC interfaces, timing and derivative
  tb/                     # VHDL filter testbenches
  ip/xadc_wiz_0.xci       # XADC IP configuration
  constraints/            # Original Artix-7 XDC constraints
  create_project.tcl      # Vivado project setup
requirements.txt
```

## Run the Python reference

```bash
pip install -r requirements.txt
python python/main.py
```

For the standalone low-pass study or recorded Bode plots:

```bash
python python/lowpass_reference.py
python python/bode_passebas.py
python python/bode_passebande.py
```

The scripts generate frequency-response plots and print coefficients scaled for FPGA fixed-point arithmetic.

## Open the FPGA project

Install **Vivado** with Artix-7 support, then from the repository root run:

```bash
vivado -mode batch -source fpga/create_project.tcl
```

The script creates `build/butterworth_vhdl/` and adds the RTL, testbenches and XADC IP configuration.

- `filter.vhd`: low-pass IIR filter.
- `band_filter.vhd`: band-pass IIR filter.
- `adc_filter.vhd` / `adc_band_filter.vhd`: XADC-to-filter integration.
- `tb_filter.vhd` / `tb_band_filter.vhd`: simulation testbenches.

The default synthesis top is `adc_filt`; choose `adc_band_filt` in Vivado for the band-pass integration. Select the corresponding testbench as simulation top. Review the original board constraints and XADC configuration before generating a bitstream.

The project sources were reorganized without changing their filtering logic. The original Vivado directory, including generated outputs, is preserved in the `backup-before-reorganization-2026-11-23` branch.
