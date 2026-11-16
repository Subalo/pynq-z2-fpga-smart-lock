## Stepper motor outputs - PMODA
set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports { stepper_phases[0] }]
set_property -dict { PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports { stepper_phases[1] }]
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports { stepper_phases[2] }]
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports { stepper_phases[3] }]

## Peripheral inputs - Arduino Header
## AR0 -> PIR sensor
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports { peripheral_inputs[0] }]

## AR1 -> Future input / photoresistor module
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { peripheral_inputs[1] }]

## AR2 -> External reset button
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports { peripheral_inputs[2] }]

## Peripheral outputs - Arduino Header
## AR3 -> PIR motion LED
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { peripheral_outputs[0] }]

## AR4 -> Buzzer
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { peripheral_outputs[1] }]

## AR5 -> Door unlocked LED
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports { peripheral_outputs[2] }]

## AR6 -> Door locked LED
set_property -dict { PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports { peripheral_outputs[3] }]

## AR7 -> Relay / future output
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { peripheral_outputs[4] }]
## ============================================================
## 4x4 Keypad Controller on PMODB - PYNQ-Z2
## Port names according to current Block Design:
## keypad_cols_0[3:0]
## keypad_rows_0[3:0]
## ============================================================

## Columns - outputs from VHDL controller
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols_0[0] }]
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols_0[1] }]
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols_0[2] }]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols_0[3] }]

## Rows - inputs to VHDL controller, with internal pull-up
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows_0[0] }]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows_0[1] }]
set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows_0[2] }]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows_0[3] }]