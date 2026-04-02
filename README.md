# Open-AI-Accelerator
A programmable 2x2 Systolic Array AI Accelerator optimized for the SkyWater 130nm process node. Featured in the Open MPW-9 shuttle.
# Open-AI-Accelerator (Project Neon)

## Overview
Project Neon is a custom-designed **2x2 Systolic Array** AI accelerator developed for the **SkyWater 130nm** process node. This hardware is optimized for the fundamental operation of modern AI: Matrix Multiplication.

## How it Works
Unlike a standard CPU that processes one instruction at a time, this architecture uses a "data-flow" method. Data "pumps" through a grid of Processing Elements (PEs), allowing multiple multiplications and additions to happen simultaneously in every clock cycle.



## Technical Specifications
* **Process Node:** SkyWater 130nm CMOS
* **Precision:** 8-bit Integer (INT8) inputs / 16-bit Accumulators
* **Interface:** * **Programmable Weights:** On-chip register file for dynamic "re-training."
    * **Control:** FSM-based execution with `start`, `ready`, and `valid` signals.
* **Target Frequency:** 50MHz - 100MHz (Estimate)

## Repository Structure
* `verilog/rtl/`: Contains the core logic and the Caravel user_project_wrapper.
* `openlane/`: Configuration files for the physical hardening flow (GDSII).
* `verilog/dv/`: Testbenches used for functional verification.

## License
This project is licensed under the **Apache License 2.0**.
