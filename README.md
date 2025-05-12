# QUIC Segmentation (VHDL / Quartus)

A VHDL project implementing a basic QUIC segmentation system, consisting of:

- 'input_buffer': Handles incoming data
- 'segmentation': Performs the segmentation logic
- 'output_buffer': (Planned) handles segmented data output

## Project Structure

- 'QUIC Input Buffer/' – Standalone Quartus project for input buffering
- 'QUIC Segmentation/' – Standalone Quartus project for segmentation
- 'QUIC Input and Seg/' – Top-level project combining input and segmentation
- 'Memory Entities/', 'Other Entities/' – Extra files, not currently used

## Usage

Each project folder contains a `.qpf` file you can open with Quartus Prime.
Only the `QUIC Input and Seg/` folder includes build artifacts (e.g., `db/`, `output_files/`) from a previous compilation — the others only contain source files and project setup.

Tested with Quartus XX.X.

## Status

Input and segmentation blocks are implemented and integrated. Output buffer is pending.

---

Created by [@laurits598](https://github.com/laurits598)
