## ============================================================
## 4x4 Keypad Test on PMODB - PYNQ-Z2
## Columns = outputs
## Rows    = inputs with internal pull-up
## ============================================================

## Keypad Columns - PMODB physical pins 1-4
## keypad_cols[0] = C1 -> PMODB pin 1
## keypad_cols[1] = C2 -> PMODB pin 2
## keypad_cols[2] = C3 -> PMODB pin 3
## keypad_cols[3] = C4 -> PMODB pin 4

set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols[0] }]
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols[1] }]
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols[2] }]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { keypad_cols[3] }]


## Keypad Rows - PMODB physical pins 7-10
## keypad_rows[0] = R1 -> PMODB pin 7
## keypad_rows[1] = R2 -> PMODB pin 8
## keypad_rows[2] = R3 -> PMODB pin 9
## keypad_rows[3] = R4 -> PMODB pin 10

set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows[0] }]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows[1] }]
set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows[2] }]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 PULLUP true } [get_ports { keypad_rows[3] }]