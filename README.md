# FPGA Smart Lock

A final-year electrical engineering project implementing a keypad-controlled lock prototype on the PYNQ-Z2. The Vivado design integrates a VHDL keypad controller, a packaged stepper motor controller, and AXI GPIO through the Zynq-7000 processing system.

[Project portfolio](https://subalo.github.io/portfolio-/#projects) · [Report](https://subalo.github.io/portfolio-/assets/docs/smart-lock-report.pdf) · [Poster](https://subalo.github.io/portfolio-/assets/docs/smart-lock-poster.pdf) · [Presentation](https://subalo.github.io/portfolio-/assets/docs/smart-lock-presentation.pptx)

## Repository layout

| Path | Contents |
| --- | --- |
| `VHDL_03/smart_lock/` | Main Vivado project, block design, keypad RTL, and I/O constraints |
| `VHDL_03/step_motor_controller/` | Stepper sequencing, clock divider, packaged IP, and testbenches |
| `VHDL_03/KEYPADTESTNEW/` | Standalone keypad RTL and testbench |
| `VHDL_03/keypad_test/` | Keypad hardware test project |
| `VHDL_03/motor_gpio_direct_test/` | Direct GPIO motor hardware test project |
| `docs/simulation/` | Simulation screenshots and a motor block diagram |

## Open the FPGA design

1. Clone this repository and open [smart_lock.xpr](VHDL_03/smart_lock/smart_lock.xpr) in **Vivado 2019.1**, the version used by the project. Install the **PYNQ-Z2** board definition and Zynq-7000 device support. The target part is `xc7z020clg400-1`.
2. Open `design_1` under **Sources**. The project references the packaged motor controller in the sibling `step_motor_controller` directory. If Vivado cannot resolve the custom IP, add that directory under **Settings → IP → Repository**.
3. Validate the block design and regenerate its output products. Run synthesis and implementation, then generate the bitstream for the board.
4. For behavioral simulation, open [step_motor_controller.xpr](VHDL_03/step_motor_controller/step_motor_controller.xpr) or [KEYPADTESTNEW.xpr](VHDL_03/KEYPADTESTNEW/KEYPADTESTNEW.xpr), choose the relevant testbench as the simulation top, and select **Run Behavioral Simulation**. Reference captures are in [docs/simulation](docs/simulation).

This snapshot contains the FPGA sources and project configuration. The supplied project folder had no Python or Jupyter application files, so reproducing any processor-side behavior described in the report requires the original application separately.
