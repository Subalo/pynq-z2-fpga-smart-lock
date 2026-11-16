# Hardware and wiring

This map shows the signal connections for the PYNQ-Z2 prototype. The pin assignments come from the [project XDC](../VHDL_03/smart_lock/smart_lock.srcs/constrs_1/new/motor_pmod.xdc) and the board definition. The sensor and indicator roles follow the [application notebook](../Python_04/FINAL_SMART_LOCK_SYSTEM.ipynb) and the [project report, pp. 50–52](https://subalo.github.io/portfolio-/assets/docs/smart-lock-report.pdf#page=50).

```mermaid
flowchart LR
    keypad["4×4 keypad"]
    sensors["PIR, light and door sensors"]
    camera["USB camera"]
    board["PYNQ-Z2"]
    driver["ULN2003 driver"]
    motor["28BYJ-48 stepper"]
    indicators["Status LEDs, buzzer and lighting relay"]

    board -->|"PMOD B pins 1–4 · columns"| keypad
    keypad -->|"PMOD B pins 7–10 · rows"| board
    sensors -->|"Arduino D0–D2"| board
    camera -->|"USB"| board
    board -->|"PMOD A pins 1–4"| driver
    driver --> motor
    board -->|"Arduino D3–D7"| indicators
```

## Power and ground

The prototype used the PYNQ-Z2 as the source for both supply rails and the common ground. The rail assignments below are based on the project author's recollection of the assembled prototype. The exact header contacts used to take 5 V, 3.3 V, and GND from the board were not recorded.

```mermaid
flowchart LR
    board["PYNQ-Z2"]
    five["5 V rail"]
    three["3.3 V rail"]
    ground["Common ground"]
    driver["ULN2003 driver"]
    loads["Relay module and buzzer"]
    sensors["PIR and LM393 light sensor modules"]
    motor["28BYJ-48 motor"]
    camera["USB camera"]
    board --> five
    five --> driver
    five --> loads
    board --> three --> sensors
    board --> ground
    driver --> ground
    loads --> ground
    sensors --> ground
    driver -->|"Motor connector"| motor
    board -->|"USB data, power and ground"| camera
```

| Component | Supply used | Ground or return |
| --- | --- | --- |
| ULN2003 motor driver | Board 5 V | Board GND |
| 28BYJ-48 stepper | Through the 5 V-powered ULN2003 driver module | Through the driver module and motor connector |
| Lighting relay module | Board 5 V on the module's control side | Board GND on the module's control side. Load-side wiring was not recorded. |
| Buzzer | Board 5 V | Board GND reference. The exact drive and return wiring was not recorded. |
| PIR motion sensor | Board 3.3 V | Board GND |
| LM393 light sensor module | Board 3.3 V | Board GND |
| Motion, unlocked, and locked LEDs | 3.3 V logic on D3, D5, and D6 | Board GND reference. Series resistor values and exact placement were not recorded. |
| MC-38 magnetic door sensor | Passive contact. D2 uses the 3.3 V logic domain. | The exact switch-to-GND connection and bias resistor arrangement were not recorded. |
| 4×4 matrix keypad | Passive row and column matrix on PMOD B | Uses the eight matrix signal wires. The XDC enables FPGA pull-ups on the row inputs. |
| Logitech Brio 300 camera | PYNQ-Z2 USB host port | Through the USB cable |

The FPGA header signals use 3.3 V logic, including the control signals to the 5 V peripherals. Check the signal levels and interfaces of the specific modules before recreating the circuit. [PYNQ-Z2 reference manual](https://dpoauwgwqsy2x.cloudfront.net/Download/pynqz2_user_manual_v1_0.pdf)

## PMOD A and PMOD B

Pin numbers refer to the physical PMOD connector. Direction is relative to the PYNQ-Z2.

| Connector | FPGA pin | RTL signal | Direction | Peripheral |
| --- | --- | --- | --- | --- |
| PMOD A 1 | Y18 | `stepper_phases[0]` | Output | ULN2003 IN1 |
| PMOD A 2 | Y19 | `stepper_phases[1]` | Output | ULN2003 IN2 |
| PMOD A 3 | Y16 | `stepper_phases[2]` | Output | ULN2003 IN3 |
| PMOD A 4 | Y17 | `stepper_phases[3]` | Output | ULN2003 IN4 |
| PMOD B 1 | W14 | `keypad_cols_0[0]` | Output | Keypad column C1 |
| PMOD B 2 | Y14 | `keypad_cols_0[1]` | Output | Keypad column C2 |
| PMOD B 3 | T11 | `keypad_cols_0[2]` | Output | Keypad column C3 |
| PMOD B 4 | T10 | `keypad_cols_0[3]` | Output | Keypad column C4 |
| PMOD B 7 | V16 | `keypad_rows_0[0]` | Input with pull-up | Keypad row R1 |
| PMOD B 8 | W16 | `keypad_rows_0[1]` | Input with pull-up | Keypad row R2 |
| PMOD B 9 | V12 | `keypad_rows_0[2]` | Input with pull-up | Keypad row R3 |
| PMOD B 10 | W13 | `keypad_rows_0[3]` | Input with pull-up | Keypad row R4 |

## Arduino digital header

| Connector | FPGA pin | RTL signal | Direction | Peripheral |
| --- | --- | --- | --- | --- |
| D0 (AR0) | T14 | `peripheral_inputs[0]` | Input | PIR motion sensor |
| D1 (AR1) | U12 | `peripheral_inputs[1]` | Input | LM393 light sensor, digital output |
| D2 (AR2) | U13 | `peripheral_inputs[2]` | Input | MC-38 magnetic door sensor |
| D3 (AR3) | V13 | `peripheral_outputs[0]` | Output | Motion indicator LED |
| D4 (AR4) | V15 | `peripheral_outputs[1]` | Output | Buzzer control |
| D5 (AR5) | T15 | `peripheral_outputs[2]` | Output | Unlocked indicator LED |
| D6 (AR6) | R16 | `peripheral_outputs[3]` | Output | Locked indicator LED |
| D7 (AR7) | U17 | `peripheral_outputs[4]` | Output | Lighting relay control |

The notebook treats a low signal on AR2 as door closed and a high signal as door open. The XDC comment labels this input as an external reset. The final report and notebook assign it to the door sensor.

## Vivado block design

The AXI interconnect connects the Zynq processing system to three GPIO blocks. `keypad_status_gpio` carries the keypad state, `motor_control_gpio` drives the motor controller inputs, and `peripherals_gpio` carries the sensor inputs and indicator outputs.

![Vivado block design showing the Zynq processing system, AXI interconnect, GPIO blocks, keypad controller, and stepper controller](media/vivado-block-design.png)
