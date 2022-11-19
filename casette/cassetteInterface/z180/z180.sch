EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L z180:Z8-L180-S180-180-PLCC-68 IC1
U 1 1 636BD5D9
P 2600 4950
F 0 "IC1" H 3450 4000 50  0000 L CNN
F 1 "Z8-L180-S180-180-PLCC-68" H 2950 3400 50  0000 L CNN
F 2 "Package_LCC:PLCC-68" H 2600 5950 50  0001 L CNN
F 3 "" H 3950 4850 50  0001 L CNN
F 4 "Zilog Z8S180 & Z8L180, Z80 Microprocessor Z180 8bit CISC 68-Pin PLCC" H 2600 6375 50  0001 L CNN "Description"
F 5 "4.57" H 3950 5950 50  0001 L CNN "Height"
F 6 "Zilog" H 3900 5850 50  0001 L CNN "Manufacturer_Name"
F 7 "Z8S18033VSG" H 2600 5850 50  0001 L CNN "Manufacturer_Part_Number"
F 8 "692-Z8S18033VSG" H 2600 5750 50  0001 L CNN "Mouser Part Number"
F 9 "https://www.mouser.com/Search/Refine.aspx?Keyword=692-Z8S18033VSG" H 2600 6275 50  0001 L CNN "Mouser Price/Stock"
F 10 "6259270" H 3950 5750 50  0001 L CNN "RS Part Number"
F 11 "http://uk.rs-online.com/web/p/products/6259270" H 2600 6175 50  0001 L CNN "RS Price/Stock"
F 12 "R1000023" H 3900 5650 50  0001 L CNN "Allied_Number"
F 13 "https://www.alliedelec.com/zilog-z8s18033vsg/R1000023/" H 2600 6075 50  0001 L CNN "Allied Price/Stock"
	1    2600 4950
	1    0    0    -1  
$EndComp
$Comp
L Memory_RAM:AS6C4008-55PCN U3
U 1 1 636BF444
P 6450 5200
F 0 "U3" H 6450 6481 50  0000 C CNN
F 1 "AS6C4008-55PCN" H 6450 6390 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 6450 5300 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C4008.pdf" H 6450 5300 50  0001 C CNN
	1    6450 5200
	1    0    0    -1  
$EndComp
$Comp
L memory:27C010 U4
U 1 1 636BFF94
P 8700 4950
F 0 "U4" H 8700 6171 70  0000 C CNN
F 1 "27C010" H 8700 6050 70  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 8700 4950 50  0001 C CNN
F 3 "" H 8700 4950 50  0001 C CNN
	1    8700 4950
	1    0    0    -1  
$EndComp
$Comp
L Logic_Programmable:GAL16V8 U1
U 1 1 636C0B21
P 2050 2700
F 0 "U1" V 2004 3444 50  0000 L CNN
F 1 "GAL16V8" V 2095 3444 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 2050 2700 50  0001 C CNN
F 3 "" H 2050 2700 50  0001 C CNN
	1    2050 2700
	0    1    1    0   
$EndComp
$Comp
L MCU_Microchip_ATmega:ATmega8A-PU U2
U 1 1 636C1AC2
P 5450 2700
F 0 "U2" V 5404 4144 50  0000 L CNN
F 1 "ATmega8A-PU" V 5495 4144 50  0000 L CNN
F 2 "Package_DIP:DIP-28_W7.62mm" H 5450 2700 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/Microchip%208bit%20mcu%20AVR%20ATmega8A%20data%20sheet%2040001974A.pdf" H 5450 2700 50  0001 C CNN
	1    5450 2700
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_Coaxial J2
U 1 1 636C4E87
P 1750 900
F 0 "J2" H 1850 875 50  0000 L CNN
F 1 "Conn_Coaxial" H 1850 784 50  0000 L CNN
F 2 "Connector_Coaxial:SMA_Amphenol_132203-12_Horizontal" H 1750 900 50  0001 C CNN
F 3 " ~" H 1750 900 50  0001 C CNN
	1    1750 900 
	1    0    0    -1  
$EndComp
$Comp
L Connector:Barrel_Jack J1
U 1 1 636C588F
P 1100 1000
F 0 "J1" H 1157 1325 50  0000 C CNN
F 1 "Barrel_Jack" H 1157 1234 50  0000 C CNN
F 2 "Connector_BarrelJack:BarrelJack_Horizontal" H 1150 960 50  0001 C CNN
F 3 "~" H 1150 960 50  0001 C CNN
	1    1100 1000
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J5
U 1 1 636CAAC0
P 5150 1550
F 0 "J5" V 5154 463 50  0000 R CNN
F 1 "Conn_02x20_Odd_Even" V 5245 463 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x20_P2.54mm_Vertical_SMD" H 5150 1550 50  0001 C CNN
F 3 "~" H 5150 1550 50  0001 C CNN
	1    5150 1550
	0    1    1    0   
$EndComp
$Comp
L pspice:CAP C1
U 1 1 636CBA8B
P 1050 1650
F 0 "C1" H 1228 1696 50  0000 L CNN
F 1 "CAP" H 1228 1605 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D10.0mm_P5.00mm_P7.50mm" H 1050 1650 50  0001 C CNN
F 3 "~" H 1050 1650 50  0001 C CNN
	1    1050 1650
	1    0    0    -1  
$EndComp
$Comp
L Device:Crystal Y1
U 1 1 636CC068
P 900 3750
F 0 "Y1" H 900 4018 50  0000 C CNN
F 1 "Crystal" H 900 3927 50  0000 C CNN
F 2 "Crystal:Crystal_AT310_D3.0mm_L10.0mm_Vertical" H 900 3750 50  0001 C CNN
F 3 "~" H 900 3750 50  0001 C CNN
	1    900  3750
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x24_Male J6
U 1 1 636F162E
P 5250 800
F 0 "J6" V 5085 728 50  0000 C CNN
F 1 "Conn_01x24_Male" V 5176 728 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x24_P2.54mm_Horizontal" H 5250 800 50  0001 C CNN
F 3 "~" H 5250 800 50  0001 C CNN
	1    5250 800 
	0    1    1    0   
$EndComp
$Comp
L Switch:SW_Push_SPDT SW1
U 1 1 63703856
P 900 4900
F 0 "SW1" H 900 5185 50  0000 C CNN
F 1 "SW_Push_SPDT" H 900 5094 50  0000 C CNN
F 2 "Button_Switch_THT:SW_Tactile_SKHH_Angled" H 900 4900 50  0001 C CNN
F 3 "~" H 900 4900 50  0001 C CNN
	1    900  4900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Female J3
U 1 1 637181C8
P 2800 950
F 0 "J3" V 2646 1098 50  0000 L CNN
F 1 "Conn_01x04_Female" V 2737 1098 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Horizontal" H 2800 950 50  0001 C CNN
F 3 "~" H 2800 950 50  0001 C CNN
	1    2800 950 
	0    1    1    0   
$EndComp
Text GLabel 2400 6500 0    50   Input ~ 0
A0
Text GLabel 2400 6600 0    50   Input ~ 0
A1
Text GLabel 2400 6700 0    50   Input ~ 0
A2
Text GLabel 2400 6800 0    50   Input ~ 0
A3
Text GLabel 2800 7200 3    50   Input ~ 0
A4
Text GLabel 2900 7200 3    50   Input ~ 0
A5
Text GLabel 3000 7200 3    50   Input ~ 0
A6
Text GLabel 3100 7200 3    50   Input ~ 0
A7
Text GLabel 3200 7200 3    50   Input ~ 0
A8
Text GLabel 3300 7200 3    50   Input ~ 0
A9
Text GLabel 3400 7200 3    50   Input ~ 0
A10
Text GLabel 3500 7200 3    50   Input ~ 0
A11
Text GLabel 3600 7200 3    50   Input ~ 0
A12
Text GLabel 3700 7200 3    50   Input ~ 0
A13
Text GLabel 3800 7200 3    50   Input ~ 0
A14
Text GLabel 3900 7200 3    50   Input ~ 0
A15
Text GLabel 4000 7200 3    50   Input ~ 0
A16
Text GLabel 4100 7200 3    50   Input ~ 0
A17
Text GLabel 4200 7200 3    50   Input ~ 0
A18
Text GLabel 4600 6800 2    50   Input ~ 0
A19
Text GLabel 5950 4700 0    50   Input ~ 0
A4
Text GLabel 5950 4800 0    50   Input ~ 0
A5
Text GLabel 5950 4900 0    50   Input ~ 0
A6
Text GLabel 5950 5000 0    50   Input ~ 0
A7
Text GLabel 5950 5100 0    50   Input ~ 0
A8
Text GLabel 5950 5200 0    50   Input ~ 0
A9
Text GLabel 5950 5300 0    50   Input ~ 0
A10
Text GLabel 5950 5400 0    50   Input ~ 0
A11
Text GLabel 5950 5500 0    50   Input ~ 0
A12
Text GLabel 5950 5600 0    50   Input ~ 0
A13
Text GLabel 5950 5700 0    50   Input ~ 0
A14
Text GLabel 5950 5800 0    50   Input ~ 0
A15
Text GLabel 5950 5900 0    50   Input ~ 0
A16
Text GLabel 5950 6000 0    50   Input ~ 0
A17
Text GLabel 5950 6100 0    50   Input ~ 0
A18
Text GLabel 5950 4300 0    50   Input ~ 0
A0
Text GLabel 5950 4400 0    50   Input ~ 0
A1
Text GLabel 5950 4500 0    50   Input ~ 0
A2
Text GLabel 5950 4600 0    50   Input ~ 0
A3
Text GLabel 8000 4450 0    50   Input ~ 0
A4
Text GLabel 8000 4550 0    50   Input ~ 0
A5
Text GLabel 8000 4650 0    50   Input ~ 0
A6
Text GLabel 8000 4750 0    50   Input ~ 0
A7
Text GLabel 8000 4850 0    50   Input ~ 0
A8
Text GLabel 8000 4950 0    50   Input ~ 0
A9
Text GLabel 8000 5050 0    50   Input ~ 0
A10
Text GLabel 8000 5150 0    50   Input ~ 0
A11
Text GLabel 8000 5250 0    50   Input ~ 0
A12
Text GLabel 8000 5350 0    50   Input ~ 0
A13
Text GLabel 8000 5450 0    50   Input ~ 0
A14
Text GLabel 8000 5550 0    50   Input ~ 0
A15
Text GLabel 8000 5650 0    50   Input ~ 0
A16
Text GLabel 8000 4050 0    50   Input ~ 0
A0
Text GLabel 8000 4150 0    50   Input ~ 0
A1
Text GLabel 8000 4250 0    50   Input ~ 0
A2
Text GLabel 8000 4350 0    50   Input ~ 0
A3
Text GLabel 4600 6600 2    50   Input ~ 0
D0
Text GLabel 4600 6500 2    50   Input ~ 0
D1
Text GLabel 4600 6600 2    50   Input ~ 0
D2
Text GLabel 4600 6400 2    50   Input ~ 0
D2
Text GLabel 4600 6300 2    50   Input ~ 0
D3
Text GLabel 4600 6200 2    50   Input ~ 0
D4
Text GLabel 4600 6100 2    50   Input ~ 0
D5
Text GLabel 4600 6000 2    50   Input ~ 0
D6
Text GLabel 4600 5900 2    50   Input ~ 0
D7
Text GLabel 6950 4300 2    50   Input ~ 0
D0
Text GLabel 6950 4400 2    50   Input ~ 0
D1
Text GLabel 6950 4300 2    50   Input ~ 0
D2
Text GLabel 6950 4500 2    50   Input ~ 0
D2
Text GLabel 6950 4600 2    50   Input ~ 0
D3
Text GLabel 6950 4700 2    50   Input ~ 0
D4
Text GLabel 6950 4800 2    50   Input ~ 0
D5
Text GLabel 6950 4900 2    50   Input ~ 0
D6
Text GLabel 6950 5000 2    50   Input ~ 0
D7
Text GLabel 9400 4050 2    50   Input ~ 0
D0
Text GLabel 9400 4150 2    50   Input ~ 0
D1
Text GLabel 9400 4050 2    50   Input ~ 0
D2
Text GLabel 9400 4250 2    50   Input ~ 0
D2
Text GLabel 9400 4350 2    50   Input ~ 0
D3
Text GLabel 9400 4450 2    50   Input ~ 0
D4
Text GLabel 9400 4550 2    50   Input ~ 0
D5
Text GLabel 9400 4650 2    50   Input ~ 0
D6
Text GLabel 9400 4750 2    50   Input ~ 0
D7
Text GLabel 4350 1000 3    50   Input ~ 0
D0
Text GLabel 4450 1000 3    50   Input ~ 0
D1
Text GLabel 4350 1000 3    50   Input ~ 0
D2
Text GLabel 4550 1000 3    50   Input ~ 0
D2
Text GLabel 4650 1000 3    50   Input ~ 0
D3
Text GLabel 4750 1000 3    50   Input ~ 0
D4
Text GLabel 4850 1000 3    50   Input ~ 0
D5
Text GLabel 4950 1000 3    50   Input ~ 0
D6
Text GLabel 5050 1000 3    50   Input ~ 0
D7
$EndSCHEMATC
