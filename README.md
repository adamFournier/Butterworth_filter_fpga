# Butterworth Low-Pass Filter — Python and FPGA

A digital Butterworth low-pass filter project. The Python implementation generates a test signal, designs the IIR filter, examines its frequency response and poles, and computes fixed-point coefficients intended for an FPGA implementation.

## Python reference

The current `main.py`:
- Generates a signal containing **1 kHz** and **10 kHz** sine waves sampled at **1 MHz**.
- Designs a **3rd-order Butterworth low-pass filter** with a **5 kHz cutoff frequency** using SciPy.
- Displays the input spectrum, frequency and phase responses, pole/zero plots, and the filtered signal.
- Prints filter coefficients and their fixed-point representations with **20** and **28 fractional bits**.
- Explores the effect of truncating coefficient precision on pole stability.

## Run

Install Python 3 and the dependencies:

```bash
pip install -r requirements.txt
python main.py
```

## Files

| File | Description |
| --- | --- |
| `main.py` | Python signal generation, Butterworth design, coefficient analysis and plots |
| `requirements.txt` | NumPy, Matplotlib and SciPy |

## FPGA implementation

The FPGA/VHDL source folder is not yet available in the current GitHub `main` branch. It can be documented here once the corresponding source files are pushed.
