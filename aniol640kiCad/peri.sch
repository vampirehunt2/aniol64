EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
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
L Zilog_Z80_Peripherals:DART-DIP-40 U?
U 1 1 622941C4
P 2500 1350
AR Path="/622941C4" Ref="U?"  Part="1" 
AR Path="/6228D96B/622941C4" Ref="U?"  Part="1" 
F 0 "U?" H 3000 1400 50  0000 C CNN
F 1 "DART" H 2600 1400 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket" H 2900 3200 50  0001 L CNN
F 3 "http://www.zilog.com/docs/z80/ps0183.pdf" H 1700 200 50  0001 L CNN
F 4 "Z80 DART Z8470 Zilog" H 2900 3000 50  0001 L CNN "Description"
F 5 "4.06" H 2900 2900 50  0001 L CNN "Height"
F 6 "Zilog" H 2900 2800 50  0001 L CNN "Manufacturer_Name"
F 7 "Z84C4206PEG" H 2900 2700 50  0001 L CNN "Manufacturer_Part_Number"
F 8 "692-Z84C4206PEG" H 2900 2600 50  0001 L CNN "Mouser Part Number"
F 9 "https://www.mouser.com/Search/Refine.aspx?Keyword=692-Z84C4206PEG" H 2900 2500 50  0001 L CNN "Mouser Price/Stock"
F 10 "6600766" H 2900 2400 50  0001 L CNN "RS Part Number"
F 11 "https://uk.rs-online.com/web/p/products/6600766" H 2900 2300 50  0001 L CNN "RS Price/Stock"
F 12 "R1000052" H 2900 2200 50  0001 L CNN "Allied_Number"
F 13 "https://www.alliedelec.com/zilog-z84c4206peg/R1000052/" H 2900 2100 50  0001 L CNN "Allied Price/Stock"
	1    2500 1350
	1    0    0    -1  
$EndComp
Text GLabel 2300 1400 0    50   Input ~ 0
D0
Text GLabel 2300 1500 0    50   Input ~ 0
D1
Text GLabel 2300 1600 0    50   Input ~ 0
D2
Text GLabel 2300 1700 0    50   Input ~ 0
D3
Text GLabel 2300 1800 0    50   Input ~ 0
D4
Text GLabel 2300 1900 0    50   Input ~ 0
D5
Text GLabel 2300 2000 0    50   Input ~ 0
D6
Text GLabel 2300 2100 0    50   Input ~ 0
D7
Text GLabel 2300 2350 0    50   Input ~ 0
RST
Text GLabel 2300 2450 0    50   Input ~ 0
M1
Text GLabel 2300 2800 0    50   Input ~ 0
CLK
Text GLabel 2300 2650 0    50   Input ~ 0
RD
Text GLabel 2300 2950 0    50   Input ~ 0
INT
Text GLabel 2300 3300 0    50   Input ~ 0
A0
Text GLabel 2300 3400 0    50   Input ~ 0
A1
Text GLabel 2300 3150 0    50   Input ~ 0
KIE
Wire Wire Line
	1850 1150 2800 1150
$Comp
L power:GND #PWR?
U 1 1 622941DB
P 2800 3650
AR Path="/622941DB" Ref="#PWR?"  Part="1" 
AR Path="/6228D96B/622941DB" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2800 3400 50  0001 C CNN
F 1 "GND" H 2805 3477 50  0000 C CNN
F 2 "" H 2800 3650 50  0001 C CNN
F 3 "" H 2800 3650 50  0001 C CNN
	1    2800 3650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 622941E1
P 2800 1150
AR Path="/622941E1" Ref="#PWR?"  Part="1" 
AR Path="/6228D96B/622941E1" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 2800 1000 50  0001 C CNN
F 1 "+5V" H 2815 1323 50  0000 C CNN
F 2 "" H 2800 1150 50  0001 C CNN
F 3 "" H 2800 1150 50  0001 C CNN
	1    2800 1150
	1    0    0    -1  
$EndComp
Connection ~ 2800 1150
Text GLabel 2300 2250 0    50   Input ~ 0
A4
Text GLabel 2300 2550 0    50   Input ~ 0
IORQ
$Comp
L Device:R_Small R?
U 1 1 622941EA
P 1950 3050
AR Path="/622941EA" Ref="R?"  Part="1" 
AR Path="/6228D96B/622941EA" Ref="R?"  Part="1" 
F 0 "R?" V 1950 2800 50  0000 L CNN
F 1 "4k7" V 2050 2950 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" H 1950 3050 50  0001 C CNN
F 3 "~" H 1950 3050 50  0001 C CNN
	1    1950 3050
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x24_Male EXP_PORT?
U 1 1 622941F0
P 8600 2250
AR Path="/622941F0" Ref="EXP_PORT?"  Part="1" 
AR Path="/6228D96B/622941F0" Ref="EXP_PORT?"  Part="1" 
F 0 "EXP_PORT?" H 8708 3531 50  0000 C CNN
F 1 "Conn_01x24_Male" H 8708 3440 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x24_P2.54mm_Horizontal" H 8600 2250 50  0001 C CNN
F 3 "~" H 8600 2250 50  0001 C CNN
	1    8600 2250
	-1   0    0    1   
$EndComp
Text GLabel 8400 3350 0    50   Input ~ 0
NMI
Text GLabel 8400 3250 0    50   Input ~ 0
INT
Text GLabel 8400 2050 0    50   Input ~ 0
WR
Text GLabel 8400 1950 0    50   Input ~ 0
RD
Text GLabel 8400 2150 0    50   Input ~ 0
IORQ
Text GLabel 8400 1850 0    50   Input ~ 0
CLK
Text GLabel 8400 1750 0    50   Input ~ 0
A7
Text GLabel 8400 1650 0    50   Input ~ 0
A2
Text GLabel 8400 1550 0    50   Input ~ 0
A1
Text GLabel 8400 1450 0    50   Input ~ 0
A0
Text GLabel 8400 1350 0    50   Input ~ 0
M1
Text GLabel 8400 1250 0    50   Input ~ 0
RST
$Comp
L power:+5V #PWR?
U 1 1 6229420A
P 8350 3950
AR Path="/6229420A" Ref="#PWR?"  Part="1" 
AR Path="/6228D96B/6229420A" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 8350 3800 50  0001 C CNN
F 1 "+5V" H 8365 4123 50  0000 C CNN
F 2 "" H 8350 3950 50  0001 C CNN
F 3 "" H 8350 3950 50  0001 C CNN
	1    8350 3950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 62294210
P 8000 3950
AR Path="/62294210" Ref="#PWR?"  Part="1" 
AR Path="/6228D96B/62294210" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 8000 3700 50  0001 C CNN
F 1 "GND" H 8005 3777 50  0000 C CNN
F 2 "" H 8000 3950 50  0001 C CNN
F 3 "" H 8000 3950 50  0001 C CNN
	1    8000 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 1150 1850 3050
$Comp
L power:GND #PWR?
U 1 1 6229421F
P 3750 1100
AR Path="/6229421F" Ref="#PWR?"  Part="1" 
AR Path="/6228D96B/6229421F" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3750 850 50  0001 C CNN
F 1 "GND" H 3755 927 50  0000 C CNN
F 2 "" H 3750 1100 50  0001 C CNN
F 3 "" H 3750 1100 50  0001 C CNN
	1    3750 1100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62294225
P 5650 1200
AR Path="/62294225" Ref="#PWR?"  Part="1" 
AR Path="/6228D96B/62294225" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 5650 1050 50  0001 C CNN
F 1 "+5V" H 5665 1373 50  0000 C CNN
F 2 "" H 5650 1200 50  0001 C CNN
F 3 "" H 5650 1200 50  0001 C CNN
	1    5650 1200
	1    0    0    -1  
$EndComp
Text GLabel 3650 2600 2    50   Input ~ 0
CLK
NoConn ~ 8400 1150
NoConn ~ 3300 2050
NoConn ~ 3300 2150
NoConn ~ 3300 2250
NoConn ~ 3300 2350
Wire Wire Line
	3300 2500 3900 2500
Wire Wire Line
	3300 2800 4100 2800
Wire Wire Line
	3300 3100 4300 3100
Wire Wire Line
	3300 3200 4400 3200
Wire Wire Line
	3300 3300 4500 3300
Wire Wire Line
	3300 1400 4500 1400
Wire Wire Line
	3300 1600 4300 1600
Wire Wire Line
	4000 2700 4000 2500
Wire Wire Line
	4100 2800 4100 2500
Wire Wire Line
	4300 3100 4300 2500
Wire Wire Line
	4400 3200 4400 2500
Wire Wire Line
	4500 3300 4500 2500
Wire Wire Line
	4500 1400 4500 2000
Wire Wire Line
	4400 1500 4400 2000
Wire Wire Line
	4300 1600 4300 2000
Wire Wire Line
	4000 2000 4000 1950
Wire Wire Line
	4000 1950 3600 1950
Wire Wire Line
	3600 1950 3600 2600
Wire Wire Line
	3300 1500 4400 1500
Wire Wire Line
	4200 1700 4200 2000
Wire Wire Line
	3300 1700 4200 1700
Wire Wire Line
	3300 1800 4100 1800
Wire Wire Line
	4100 1800 4100 2000
Text GLabel 3850 2900 2    50   Input ~ 0
WAIT
Wire Wire Line
	3300 3400 4200 3400
Wire Wire Line
	3850 2900 3400 2900
Wire Wire Line
	3300 1900 3400 1900
$Comp
L Connector_Generic:Conn_02x08_Odd_Even SERIAL?
U 1 1 6229424D
P 4300 2200
AR Path="/6229424D" Ref="SERIAL?"  Part="1" 
AR Path="/6228D96B/6229424D" Ref="SERIAL?"  Part="1" 
F 0 "SERIAL?" H 4250 1700 50  0000 L CNN
F 1 "Conn_02x08_Odd_Even" V 4350 1700 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x08_P2.54mm_Horizontal" H 4300 2200 50  0001 C CNN
F 3 "~" H 4300 2200 50  0001 C CNN
	1    4300 2200
	0    1    1    0   
$EndComp
Wire Wire Line
	4200 2500 4200 3400
Connection ~ 3600 2600
Wire Wire Line
	3600 2600 3650 2600
Wire Wire Line
	3300 2600 3600 2600
Wire Wire Line
	3300 2700 4000 2700
Wire Wire Line
	3400 1900 3400 2900
Connection ~ 3400 2900
Wire Wire Line
	3400 2900 3300 2900
Wire Wire Line
	3750 1100 3900 1100
Wire Wire Line
	3900 1100 3900 2000
Wire Wire Line
	5650 2500 5650 1200
Wire Wire Line
	2050 3050 2300 3050
Wire Wire Line
	8000 3050 8400 3050
Wire Wire Line
	8000 3050 8000 3950
Wire Wire Line
	8350 3950 8100 3950
Wire Wire Line
	8100 3950 8100 3150
Wire Wire Line
	8100 3150 8400 3150
Wire Wire Line
	8450 2450 8400 2450
Wire Wire Line
	8450 2550 8400 2550
Wire Wire Line
	8450 2650 8400 2650
Wire Wire Line
	8450 2750 8400 2750
Wire Wire Line
	8450 2850 8400 2850
Wire Wire Line
	8450 2950 8400 2950
$Comp
L 74xx:74LS14 U?
U 6 1 6320FDDD
P 4900 2000
F 0 "U?" H 4900 2317 50  0000 C CNN
F 1 "74LS14" H 4900 2226 50  0000 C CNN
F 2 "" H 4900 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 4900 2000 50  0001 C CNN
	6    4900 2000
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 6321FB1E
P 5200 1750
F 0 "R?" H 5259 1796 50  0000 L CNN
F 1 "R_Small" H 5259 1705 50  0000 L CNN
F 2 "" H 5200 1750 50  0001 C CNN
F 3 "~" H 5200 1750 50  0001 C CNN
	1    5200 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 1650 5200 1500
Wire Wire Line
	5200 2000 5200 1850
Wire Wire Line
	5200 1500 4400 1500
Connection ~ 4400 1500
Wire Wire Line
	4600 2500 5650 2500
Text GLabel 8400 2250 0    50   Input ~ 0
D7
Text GLabel 8400 2350 0    50   Input ~ 0
D6
Text GLabel 8400 2450 0    50   Input ~ 0
D5
Text GLabel 8400 2550 0    50   Input ~ 0
D4
Text GLabel 8400 2650 0    50   Input ~ 0
D3
Text GLabel 8400 2750 0    50   Input ~ 0
D2
Text GLabel 8400 2850 0    50   Input ~ 0
D1
Text GLabel 8400 2950 0    50   Input ~ 0
D0
$EndSCHEMATC
