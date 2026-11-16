# FPGA Smart Lock

A final-year electrical engineering project implementing a keypad-controlled lock prototype on the PYNQ-Z2. The Vivado design integrates a VHDL keypad controller, a packaged stepper motor controller, and AXI GPIO through the Zynq-7000 processing system.

I tested the Smart Lock system on a physical PYNQ-Z2 board and confirmed that it works.

[Project portfolio](https://subalo.github.io/portfolio-/#projects) · [Report](https://subalo.github.io/portfolio-/assets/docs/smart-lock-report.pdf) · [Poster](https://subalo.github.io/portfolio-/assets/docs/smart-lock-poster.pdf) · [Presentation](https://subalo.github.io/portfolio-/assets/docs/smart-lock-presentation.pptx)

## Repository layout

| Path | Contents |
| --- | --- |
| `VHDL_03/smart_lock/` | Main Vivado project, block design, keypad RTL, and I/O constraints |
| `VHDL_03/step_motor_controller/` | Stepper sequencing, clock divider, packaged IP, and testbenches |
| `VHDL_03/KEYPADTESTNEW/` | Standalone keypad RTL and testbench |
| `VHDL_03/keypad_test/` | Keypad hardware test project |
| `VHDL_03/motor_gpio_direct_test/` | Direct GPIO motor hardware test project |
| `Python_04/` | PYNQ application notebook for the keypad, camera, lock actuator, and optional Telegram alerts |
| `docs/simulation/` | Simulation screenshots and a motor block diagram |

## Open the FPGA design

1. Clone this repository and open [smart_lock.xpr](VHDL_03/smart_lock/smart_lock.xpr) in **Vivado 2019.1**, the version used by the project. Install the **PYNQ-Z2** board definition and Zynq-7000 device support. The target part is `xc7z020clg400-1`.
2. Open `design_1` under **Sources**. The project references the packaged motor controller in the sibling `step_motor_controller` directory. If Vivado cannot resolve the custom IP, add that directory under **Settings → IP → Repository**.
3. Validate the block design and regenerate its output products. Run synthesis and implementation, then generate the bitstream for the board.
4. For behavioral simulation, open [step_motor_controller.xpr](VHDL_03/step_motor_controller/step_motor_controller.xpr) or [KEYPADTESTNEW.xpr](VHDL_03/KEYPADTESTNEW/KEYPADTESTNEW.xpr), choose the relevant testbench as the simulation top, and select **Run Behavioral Simulation**. Reference captures are in [docs/simulation](docs/simulation).

## Run the application on PYNQ-Z2

1. Boot the board with its PYNQ image and open Jupyter. Copy [FINAL_SMART_LOCK_SYSTEM.ipynb](Python_04/FINAL_SMART_LOCK_SYSTEM.ipynb) into a dedicated directory. The Python kernel needs `pynq`, `requests`, and an OpenCV build with `cv2.face.LBPHFaceRecognizer_create`. Connect the camera and wire the project peripherals according to the report.
2. Download both overlay files from the [v1.0.0 release](https://github.com/Subalo/smart-lock-fpga/releases/tag/v1.0.0) and place them alongside the notebook. The prebuilt overlay lets you skip the Vivado build. Add the remaining files as described below.

   | File | Source |
   | --- | --- |
   | `design_1.bit` | [Download the prebuilt bitstream](https://github.com/Subalo/smart-lock-fpga/releases/download/v1.0.0/design_1.bit). If rebuilding, copy `smart_lock.runs/impl_1/design_1_wrapper.bit` as `design_1.bit`. |
   | `design_1.hwh` | [Download the matching hardware handoff](https://github.com/Subalo/smart-lock-fpga/releases/download/v1.0.0/design_1.hwh). If rebuilding, copy `smart_lock.srcs/sources_1/bd/design_1/hw_handoff/design_1.hwh` from the same build as the bitstream. Keep both files together with the same base name. |
   | `trainer.yml` | Supply an OpenCV LBPH model trained on your authorized user's images. The notebook expects that user's label to match `AUTHORIZED_USER_ID` (default `1`). Keep the trained model and training images private. |
   | `haarcascade_frontalface_default.xml` | Copy the OpenCV face detector XML into this directory if it is unavailable in the board's OpenCV or PYNQ data directory. |

3. Create `smart_lock.local.json` in the same directory. Replace `SET_YOUR_CODE` with 1–8 digits, keeping the quotes so that leading zeros are preserved. Leave both Telegram fields empty to disable notifications.

   ```json
   {
     "keypad_code": "SET_YOUR_CODE",
     "telegram_bot_token": "",
     "telegram_chat_id": ""
   }
   ```

4. Open the notebook in Jupyter from that directory and run the setup cell, then the start cell. Wait for `System is ready.` before testing the keypad or camera. Stop the running cell to end the program. The access log and captured images are saved locally beside the notebook.

[PYNQ overlay documentation](https://pynq.readthedocs.io/en/latest/pynq_overlays/loading_an_overlay.html) · [OpenCV LBPH documentation](https://docs.opencv.org/4.13.0/df/d25/classcv_1_1face_1_1LBPHFaceRecognizer.html)
