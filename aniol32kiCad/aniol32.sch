EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 5
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
L power:GND #PWR010
U 1 1 614DA181
P 3600 4300
F 0 "#PWR010" H 3600 4050 50  0001 C CNN
F 1 "GND" H 3605 4127 50  0000 C CNN
F 2 "" H 3600 4300 50  0001 C CNN
F 3 "" H 3600 4300 50  0001 C CNN
	1    3600 4300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR09
U 1 1 614DA809
P 3600 1300
F 0 "#PWR09" H 3600 1150 50  0001 C CNN
F 1 "+5V" H 3615 1473 50  0000 C CNN
F 2 "" H 3600 1300 50  0001 C CNN
F 3 "" H 3600 1300 50  0001 C CNN
	1    3600 1300
	1    0    0    -1  
$EndComp
$Comp
L CPU:Z80CPU CPU1
U 1 1 614D8061
P 3600 2800
F 0 "CPU1" H 3600 3800 50  0000 C CNN
F 1 "Z80" H 3600 3700 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket" H 3600 3200 50  0001 C CNN
F 3 "www.zilog.com/manage_directlink.php?filepath=docs/z80/um0080" H 3600 3200 50  0001 C CNN
	1    3600 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 3300 4300 3300
Wire Wire Line
	4350 3400 4300 3400
Wire Wire Line
	4350 3500 4300 3500
Wire Wire Line
	4350 3600 4300 3600
Wire Wire Line
	4350 3700 4300 3700
Wire Wire Line
	4350 3800 4300 3800
Wire Wire Line
	4350 3900 4300 3900
Wire Wire Line
	4350 4000 4300 4000
Wire Wire Line
	6950 1550 6900 1550
Wire Wire Line
	6950 1650 6900 1650
Wire Wire Line
	6950 1750 6900 1750
Wire Wire Line
	6950 1850 6900 1850
Wire Wire Line
	6950 1950 6900 1950
Wire Wire Line
	6950 2050 6900 2050
Wire Wire Line
	6950 2150 6900 2150
Wire Wire Line
	6950 2250 6900 2250
$Comp
L power:+5V #PWR011
U 1 1 61543143
P 6500 1250
F 0 "#PWR011" H 6500 1100 50  0001 C CNN
F 1 "+5V" H 6515 1423 50  0000 C CNN
F 2 "" H 6500 1250 50  0001 C CNN
F 3 "" H 6500 1250 50  0001 C CNN
	1    6500 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 615B1E50
P 2300 2200
F 0 "R11" V 2200 2200 50  0000 C CNN
F 1 "4k7" V 2300 2200 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2230 2200 50  0001 C CNN
F 3 "~" H 2300 2200 50  0001 C CNN
	1    2300 2200
	0    1    1    0   
$EndComp
$Comp
L Device:R R14
U 1 1 615B3014
P 2300 3900
F 0 "R14" V 2200 3900 50  0000 C CNN
F 1 "1k" V 2300 3900 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2230 3900 50  0001 C CNN
F 3 "~" H 2300 3900 50  0001 C CNN
	1    2300 3900
	0    1    1    0   
$EndComp
$Comp
L Device:R R13
U 1 1 615B39BC
P 2300 2800
F 0 "R13" V 2200 2800 50  0000 C CNN
F 1 "4k7" V 2300 2800 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2230 2800 50  0001 C CNN
F 3 "~" H 2300 2800 50  0001 C CNN
	1    2300 2800
	0    1    1    0   
$EndComp
Connection ~ 2150 2800
Wire Wire Line
	2150 2800 2150 3900
$Comp
L power:+5V #PWR08
U 1 1 615C2A89
P 2150 1300
F 0 "#PWR08" H 2150 1150 50  0001 C CNN
F 1 "+5V" H 2165 1473 50  0000 C CNN
F 2 "" H 2150 1300 50  0001 C CNN
F 3 "" H 2150 1300 50  0001 C CNN
	1    2150 1300
	1    0    0    -1  
$EndComp
Text GLabel 2900 3300 0    50   Input ~ 0
RD
Text GLabel 2900 3400 0    50   Input ~ 0
WR
Text GLabel 2900 1600 0    50   Input ~ 0
RST
Text GLabel 2900 1900 0    50   Input ~ 0
CLK
NoConn ~ 2900 2700
$Comp
L Device:CP C1
U 1 1 619E059B
P 850 7050
F 0 "C1" H 968 7096 50  0000 L CNN
F 1 "100u" H 968 7005 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D14.0mm_P7.50mm" H 888 6900 50  0001 C CNN
F 3 "~" H 850 7050 50  0001 C CNN
	1    850  7050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U4
U 5 1 619E13D8
P 3000 7050
F 0 "U4" H 2950 7650 50  0000 L CNN
F 1 "74LS32" H 2850 7050 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3000 7050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 3000 7050 50  0001 C CNN
	5    3000 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	850  6550 1150 6550
Connection ~ 2100 6550
Wire Wire Line
	850  7550 850  7200
Connection ~ 2100 7550
Wire Wire Line
	850  6550 850  6900
$Comp
L power:GND #PWR04
U 1 1 61A76495
P 850 7550
F 0 "#PWR04" H 850 7300 50  0001 C CNN
F 1 "GND" H 855 7377 50  0000 C CNN
F 2 "" H 850 7550 50  0001 C CNN
F 3 "" H 850 7550 50  0001 C CNN
	1    850  7550
	1    0    0    -1  
$EndComp
Connection ~ 850  7550
$Comp
L power:+5V #PWR03
U 1 1 61A770D0
P 850 6550
F 0 "#PWR03" H 850 6400 50  0001 C CNN
F 1 "+5V" H 865 6723 50  0000 C CNN
F 2 "" H 850 6550 50  0001 C CNN
F 3 "" H 850 6550 50  0001 C CNN
	1    850  6550
	1    0    0    -1  
$EndComp
Connection ~ 850  6550
Wire Wire Line
	2150 2200 2150 1300
Connection ~ 2150 2200
Text GLabel 2900 3600 0    50   Input ~ 0
IORQ
Text GLabel 2900 3500 0    50   Input ~ 0
MEMRQ
Text GLabel 2900 2600 0    50   Input ~ 0
M1
$Comp
L power:GND #PWR018
U 1 1 61973CEA
P 14750 6250
F 0 "#PWR018" H 14750 6000 50  0001 C CNN
F 1 "GND" H 14755 6077 50  0000 C CNN
F 2 "" H 14750 6250 50  0001 C CNN
F 3 "" H 14750 6250 50  0001 C CNN
	1    14750 6250
	1    0    0    -1  
$EndComp
NoConn ~ 2900 4000
$Sheet
S 1200 1900 500  150 
U 61AEA36E
F0 "keyboard" 50
F1 "Kbd.sch" 50
$EndSheet
$Sheet
S 1200 2300 500  150 
U 61ACCEA5
F0 "HD44780 LCD" 50
F1 "LCD.sch" 50
$EndSheet
$Comp
L power:GND #PWR012
U 1 1 61540686
P 6500 3550
F 0 "#PWR012" H 6500 3300 50  0001 C CNN
F 1 "GND" H 6600 3550 50  0000 C CNN
F 2 "" H 6500 3550 50  0001 C CNN
F 3 "" H 6500 3550 50  0001 C CNN
	1    6500 3550
	1    0    0    -1  
$EndComp
Text GLabel 4300 1600 2    50   Input ~ 0
A0
Text GLabel 4300 1700 2    50   Input ~ 0
A1
Text GLabel 4300 1800 2    50   Input ~ 0
A2
Text GLabel 4300 1900 2    50   Input ~ 0
A3
Text GLabel 4300 2000 2    50   Input ~ 0
A4
Text GLabel 4300 2100 2    50   Input ~ 0
A5
Text GLabel 4300 2200 2    50   Input ~ 0
A6
Text GLabel 4300 2300 2    50   Input ~ 0
A7
Text GLabel 4300 2400 2    50   Input ~ 0
A8
Text GLabel 4300 2500 2    50   Input ~ 0
A9
Text GLabel 4300 2600 2    50   Input ~ 0
A10
Text GLabel 4300 2700 2    50   Input ~ 0
A11
Text GLabel 4300 2800 2    50   Input ~ 0
A12
Text GLabel 4300 2900 2    50   Input ~ 0
A13
Text GLabel 4300 3000 2    50   Input ~ 0
A14
Text GLabel 4350 3300 2    50   Input ~ 0
D0
Text GLabel 4350 3400 2    50   Input ~ 0
D1
Text GLabel 4350 3500 2    50   Input ~ 0
D2
Text GLabel 4350 3600 2    50   Input ~ 0
D3
Text GLabel 4350 3700 2    50   Input ~ 0
D4
Text GLabel 4350 3800 2    50   Input ~ 0
D5
Text GLabel 4350 3900 2    50   Input ~ 0
D6
Text GLabel 4350 4000 2    50   Input ~ 0
D7
Text GLabel 6950 1550 2    50   Input ~ 0
D0
Text GLabel 6950 1650 2    50   Input ~ 0
D1
Text GLabel 6950 1750 2    50   Input ~ 0
D2
Text GLabel 6950 1850 2    50   Input ~ 0
D3
Text GLabel 6950 1950 2    50   Input ~ 0
D4
Text GLabel 6950 2050 2    50   Input ~ 0
D5
Text GLabel 6950 2150 2    50   Input ~ 0
D6
Text GLabel 6950 2250 2    50   Input ~ 0
D7
Text GLabel 6100 2950 0    50   Input ~ 0
A14
Text GLabel 6100 2350 0    50   Input ~ 0
A8
Text GLabel 6100 2850 0    50   Input ~ 0
A13
Text GLabel 6100 2750 0    50   Input ~ 0
A12
Text GLabel 6100 2650 0    50   Input ~ 0
A11
Text GLabel 6100 2550 0    50   Input ~ 0
A10
Text GLabel 6100 2450 0    50   Input ~ 0
A9
Text GLabel 6100 2250 0    50   Input ~ 0
A7
Text GLabel 6100 2150 0    50   Input ~ 0
A6
Text GLabel 6100 2050 0    50   Input ~ 0
A5
Text GLabel 6100 1950 0    50   Input ~ 0
A4
Text GLabel 6100 1850 0    50   Input ~ 0
A3
Text GLabel 6100 1750 0    50   Input ~ 0
A2
Text GLabel 6100 1650 0    50   Input ~ 0
A1
Text GLabel 6100 1550 0    50   Input ~ 0
A0
$Comp
L Memory_EEPROM:28C256 ROM1
U 1 1 6177E09D
P 6500 2450
F 0 "ROM1" H 6500 2850 50  0000 C CNN
F 1 "28C256" H 6500 2500 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket" H 6500 2450 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 6500 2450 50  0001 C CNN
	1    6500 2450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 61D165C5
P 1800 5600
F 0 "#PWR02" H 1800 5350 50  0001 C CNN
F 1 "GND" H 1805 5427 50  0000 C CNN
F 2 "" H 1800 5600 50  0001 C CNN
F 3 "" H 1800 5600 50  0001 C CNN
	1    1800 5600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR01
U 1 1 61D16900
P 1800 4450
F 0 "#PWR01" H 1800 4300 50  0001 C CNN
F 1 "+5V" H 1815 4623 50  0000 C CNN
F 2 "" H 1800 4450 50  0001 C CNN
F 3 "" H 1800 4450 50  0001 C CNN
	1    1800 4450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R2
U 1 1 61D1747F
P 1800 4650
F 0 "R2" H 1859 4696 50  0000 L CNN
F 1 "4k7" H 1859 4605 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" H 1800 4650 50  0001 C CNN
F 3 "~" H 1800 4650 50  0001 C CNN
	1    1800 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 4450 1800 4550
Wire Wire Line
	1800 4750 1800 4950
Text GLabel 2000 4950 2    50   Input ~ 0
RST
Wire Wire Line
	2000 4950 1800 4950
Connection ~ 1800 4950
$Comp
L 74xx:74LS14 U2
U 7 1 61D22ED5
P 2100 7050
F 0 "U2" H 2000 7650 50  0000 L CNN
F 1 "74LS14" H 2000 7050 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 2100 7050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 2100 7050 50  0001 C CNN
	7    2100 7050
	1    0    0    -1  
$EndComp
Connection ~ 3000 6550
Connection ~ 3000 7550
$Comp
L 74xx:74LS74 U12
U 3 1 61D34352
P 3900 7050
F 0 "U12" H 3800 7650 50  0000 L CNN
F 1 "74LS74" H 3800 7050 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 3900 7050 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 3900 7050 50  0001 C CNN
	3    3900 7050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 6550 3900 6650
Connection ~ 3900 6550
Wire Wire Line
	3900 6550 4300 6550
Wire Wire Line
	3900 7550 3900 7450
Connection ~ 3900 7550
$Comp
L Oscillator:ACO-xxxMHz X1
U 1 1 61D3D043
P 5550 5050
F 0 "X1" H 5207 5096 50  0000 R CNN
F 1 "ACO-1.8432MHz" H 5207 5005 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 6000 4700 50  0001 C CNN
F 3 "http://www.conwin.com/datasheets/cx/cx030.pdf" H 5450 5050 50  0001 C CNN
	1    5550 5050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR014
U 1 1 61D3E347
P 5550 4750
F 0 "#PWR014" H 5550 4600 50  0001 C CNN
F 1 "+5V" H 5565 4923 50  0000 C CNN
F 2 "" H 5550 4750 50  0001 C CNN
F 3 "" H 5550 4750 50  0001 C CNN
	1    5550 4750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR015
U 1 1 61D3EB67
P 5550 5350
F 0 "#PWR015" H 5550 5100 50  0001 C CNN
F 1 "GND" H 5555 5177 50  0000 C CNN
F 2 "" H 5550 5350 50  0001 C CNN
F 3 "" H 5550 5350 50  0001 C CNN
	1    5550 5350
	1    0    0    -1  
$EndComp
Text GLabel 6450 5050 2    50   Input ~ 0
CLK
$Comp
L Device:C_Small C2
U 1 1 61D4048B
P 4300 7100
F 0 "C2" H 4250 7300 50  0000 L CNN
F 1 "100n" H 4200 6950 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 4300 7100 50  0001 C CNN
F 3 "~" H 4300 7100 50  0001 C CNN
	1    4300 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C3
U 1 1 61D40D4F
P 4450 7100
F 0 "C3" H 4400 7300 50  0000 L CNN
F 1 "100n" H 4300 6850 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 4450 7100 50  0001 C CNN
F 3 "~" H 4450 7100 50  0001 C CNN
	1    4450 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 61D41746
P 4600 7100
F 0 "C4" H 4550 7300 50  0000 L CNN
F 1 "100n" H 4450 6950 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 4600 7100 50  0001 C CNN
F 3 "~" H 4600 7100 50  0001 C CNN
	1    4600 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 61D41F77
P 4750 7100
F 0 "C5" H 4700 7300 50  0000 L CNN
F 1 "100n" H 4600 6850 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 4750 7100 50  0001 C CNN
F 3 "~" H 4750 7100 50  0001 C CNN
	1    4750 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C6
U 1 1 61D42877
P 4900 7100
F 0 "C6" H 4850 7300 50  0000 L CNN
F 1 "100n" H 4750 6950 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 4900 7100 50  0001 C CNN
F 3 "~" H 4900 7100 50  0001 C CNN
	1    4900 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C7
U 1 1 61D43149
P 5050 7100
F 0 "C7" H 5000 7300 50  0000 L CNN
F 1 "100n" H 4900 6850 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 5050 7100 50  0001 C CNN
F 3 "~" H 5050 7100 50  0001 C CNN
	1    5050 7100
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C8
U 1 1 61D44921
P 5200 7100
F 0 "C8" H 5150 7300 50  0000 L CNN
F 1 "100n" H 5050 6950 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 5200 7100 50  0001 C CNN
F 3 "~" H 5200 7100 50  0001 C CNN
	1    5200 7100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 7550 4300 7550
Wire Wire Line
	4300 7000 4450 7000
Connection ~ 4450 7000
Wire Wire Line
	4450 7000 4600 7000
Connection ~ 4600 7000
Wire Wire Line
	4600 7000 4750 7000
Connection ~ 4750 7000
Wire Wire Line
	4750 7000 4900 7000
Connection ~ 4900 7000
Wire Wire Line
	4900 7000 5050 7000
Connection ~ 5050 7000
Wire Wire Line
	5050 7000 5200 7000
Wire Wire Line
	4300 7200 4450 7200
Connection ~ 4450 7200
Wire Wire Line
	4450 7200 4600 7200
Connection ~ 4600 7200
Wire Wire Line
	4600 7200 4750 7200
Connection ~ 4750 7200
Wire Wire Line
	4750 7200 4900 7200
Connection ~ 4900 7200
Wire Wire Line
	4900 7200 5050 7200
Connection ~ 5050 7200
Wire Wire Line
	5050 7200 5200 7200
$Comp
L Connector:Conn_01x02_Male J2
U 1 1 61D552DF
P 2350 5350
F 0 "J2" H 2458 5531 50  0000 C CNN
F 1 "PWR" H 2250 5300 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2350 5350 50  0001 C CNN
F 3 "~" H 2350 5350 50  0001 C CNN
	1    2350 5350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR06
U 1 1 61D56634
P 2550 5450
F 0 "#PWR06" H 2550 5200 50  0001 C CNN
F 1 "GND" H 2555 5277 50  0000 C CNN
F 2 "" H 2550 5450 50  0001 C CNN
F 3 "" H 2550 5450 50  0001 C CNN
	1    2550 5450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR05
U 1 1 61D56F4A
P 2550 5350
F 0 "#PWR05" H 2550 5200 50  0001 C CNN
F 1 "+5V" H 2565 5523 50  0000 C CNN
F 2 "" H 2550 5350 50  0001 C CNN
F 3 "" H 2550 5350 50  0001 C CNN
	1    2550 5350
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J1
U 1 1 61D57B45
P 1600 5300
F 0 "J1" H 1708 5481 50  0000 C CNN
F 1 "RST" H 1500 5250 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 1600 5300 50  0001 C CNN
F 3 "~" H 1600 5300 50  0001 C CNN
	1    1600 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1800 4950 1800 5300
Wire Wire Line
	1800 5400 1800 5600
Wire Wire Line
	2150 2200 2150 2300
Text GLabel 2400 2500 0    50   Input ~ 0
INT
Text GLabel 7950 5900 1    50   Input ~ 0
NMI
Text GLabel 8050 5900 1    50   Input ~ 0
INT
Text GLabel 8350 5900 1    50   Input ~ 0
D0
Text GLabel 8450 5900 1    50   Input ~ 0
D1
Text GLabel 8550 5900 1    50   Input ~ 0
D2
Text GLabel 8650 5900 1    50   Input ~ 0
D3
Text GLabel 8750 5900 1    50   Input ~ 0
D4
Text GLabel 8850 5900 1    50   Input ~ 0
D5
Text GLabel 8950 5900 1    50   Input ~ 0
D6
Text GLabel 9050 5900 1    50   Input ~ 0
D7
Text GLabel 9150 5900 1    50   Input ~ 0
WR
Text GLabel 9250 5900 1    50   Input ~ 0
RD
Text GLabel 9350 5900 1    50   Input ~ 0
IORQ
Text GLabel 9450 5900 1    50   Input ~ 0
CLK
Text GLabel 9550 5900 1    50   Input ~ 0
A7
Text GLabel 9650 5900 1    50   Input ~ 0
A2
Text GLabel 9750 5900 1    50   Input ~ 0
A1
Text GLabel 9850 5900 1    50   Input ~ 0
A0
Text GLabel 9950 5900 1    50   Input ~ 0
M1
Text GLabel 10050 5900 1    50   Input ~ 0
RST
$Comp
L power:+5V #PWR0101
U 1 1 61D8F03A
P 8150 5300
F 0 "#PWR0101" H 8150 5150 50  0001 C CNN
F 1 "+5V" H 8250 5400 50  0000 C CNN
F 2 "" H 8150 5300 50  0001 C CNN
F 3 "" H 8150 5300 50  0001 C CNN
	1    8150 5300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 61D8FAA1
P 8400 5400
F 0 "#PWR0102" H 8400 5150 50  0001 C CNN
F 1 "GND" H 8405 5227 50  0000 C CNN
F 2 "" H 8400 5400 50  0001 C CNN
F 3 "" H 8400 5400 50  0001 C CNN
	1    8400 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 5400 8250 5400
Wire Wire Line
	8250 5400 8250 5900
Wire Wire Line
	2900 2200 2550 2200
Wire Wire Line
	2900 2800 2550 2800
Wire Wire Line
	2900 3900 2450 3900
NoConn ~ 2900 2900
Text GLabel 2400 2000 0    50   Input ~ 0
NMI
Connection ~ 2550 2200
Wire Wire Line
	2550 2200 2450 2200
Wire Wire Line
	4300 7000 4300 6550
Connection ~ 4300 7000
Wire Wire Line
	4300 7200 4300 7550
Connection ~ 4300 7200
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 6208B890
P 1150 6550
F 0 "#FLG0101" H 1150 6625 50  0001 C CNN
F 1 "PWR_FLAG" H 1150 6723 50  0000 C CNN
F 2 "" H 1150 6550 50  0001 C CNN
F 3 "~" H 1150 6550 50  0001 C CNN
	1    1150 6550
	1    0    0    -1  
$EndComp
Connection ~ 1150 6550
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 6208C613
P 1150 7550
F 0 "#FLG0102" H 1150 7625 50  0001 C CNN
F 1 "PWR_FLAG" H 1150 7723 50  0000 C CNN
F 2 "" H 1150 7550 50  0001 C CNN
F 3 "~" H 1150 7550 50  0001 C CNN
	1    1150 7550
	1    0    0    -1  
$EndComp
Connection ~ 1150 7550
Wire Wire Line
	1150 7550 850  7550
Text GLabel 2450 3050 0    50   Input ~ 0
WAIT
Wire Wire Line
	2450 3050 2550 3050
Wire Wire Line
	2550 3050 2550 2800
Connection ~ 2550 2800
Wire Wire Line
	2550 2800 2450 2800
Text GLabel 6100 3250 0    50   Input ~ 0
MEMRQ
$Comp
L 74xx:74LS14 U2
U 1 1 621EE5D7
P 6150 5050
F 0 "U2" H 6150 5367 50  0000 C CNN
F 1 "74LS14" H 6150 5276 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 6150 5050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 6150 5050 50  0001 C CNN
	1    6150 5050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 6550 2100 6550
Wire Wire Line
	1150 7550 2100 7550
$Comp
L Connector:Conn_01x24_Male EXP_PORT1
U 1 1 61D74C8B
P 9050 6100
F 0 "EXP_PORT1" H 9158 7381 50  0000 C CNN
F 1 "Conn_01x24_Male" H 9158 7290 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x24_P2.54mm_Horizontal" H 9050 6100 50  0001 C CNN
F 3 "~" H 9050 6100 50  0001 C CNN
	1    9050 6100
	0    -1   -1   0   
$EndComp
Text GLabel 10150 5900 1    50   Input ~ 0
WAIT
$Sheet
S 1200 1500 500  150 
U 624CEC4A
F0 "simpleKbd" 50
F1 "simpleKbd.sch" 50
$EndSheet
$Sheet
S 1200 2800 500  150 
U 6262EA81
F0 "dart" 50
F1 "file6262EA80.sch" 50
$EndSheet
Wire Wire Line
	6500 1350 6500 1300
Wire Wire Line
	6500 1300 5500 1300
Wire Wire Line
	5500 1300 5500 3150
Wire Wire Line
	5500 3150 6100 3150
Connection ~ 6500 1300
Wire Wire Line
	6500 1300 6500 1250
Text GLabel 6100 3350 0    50   Input ~ 0
A15
Text GLabel 4300 3100 2    50   Input ~ 0
A15
$Comp
L memory:6116 RAM
U 1 1 625F1611
P 8650 2150
F 0 "RAM" H 8800 1800 50  0000 C CNN
F 1 "6116" H 8800 1650 50  0000 C CNN
F 2 "" H 8650 2150 50  0001 C CNN
F 3 "" H 8650 2150 50  0001 C CNN
	1    8650 2150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 625F1FBB
P 8650 1100
F 0 "#PWR?" H 8650 950 50  0001 C CNN
F 1 "+5V" H 8665 1273 50  0000 C CNN
F 2 "" H 8650 1100 50  0001 C CNN
F 3 "" H 8650 1100 50  0001 C CNN
	1    8650 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 1100 8650 1400
$Comp
L power:GND #PWR?
U 1 1 625F6DC8
P 8650 3050
F 0 "#PWR?" H 8650 2800 50  0001 C CNN
F 1 "GND" H 8750 3050 50  0000 C CNN
F 2 "" H 8650 3050 50  0001 C CNN
F 3 "" H 8650 3050 50  0001 C CNN
	1    8650 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 2900 8650 3050
Text GLabel 9250 1450 2    50   Input ~ 0
D0
Text GLabel 9250 1550 2    50   Input ~ 0
D1
Text GLabel 9250 1650 2    50   Input ~ 0
D2
Text GLabel 9250 1750 2    50   Input ~ 0
D3
Text GLabel 9250 1850 2    50   Input ~ 0
D4
Text GLabel 9250 1950 2    50   Input ~ 0
D5
Text GLabel 9250 2050 2    50   Input ~ 0
D6
Text GLabel 9250 2150 2    50   Input ~ 0
D7
Text GLabel 8050 2250 0    50   Input ~ 0
A8
Text GLabel 8050 2450 0    50   Input ~ 0
A10
Text GLabel 8050 2350 0    50   Input ~ 0
A9
Text GLabel 8050 2150 0    50   Input ~ 0
A7
Text GLabel 8050 2050 0    50   Input ~ 0
A6
Text GLabel 8050 1950 0    50   Input ~ 0
A5
Text GLabel 8050 1850 0    50   Input ~ 0
A4
Text GLabel 8050 1750 0    50   Input ~ 0
A3
Text GLabel 8050 1650 0    50   Input ~ 0
A2
Text GLabel 8050 1550 0    50   Input ~ 0
A1
Text GLabel 8050 1450 0    50   Input ~ 0
A0
Text GLabel 8050 2650 0    50   Input ~ 0
RD
Text GLabel 8050 2750 0    50   Input ~ 0
WR
$Comp
L 74xx:74LS32 U?
U 4 1 6260C85A
P 8050 3500
F 0 "U?" V 8096 3320 50  0000 R CNN
F 1 "74LS32" V 8005 3320 50  0000 R CNN
F 2 "" H 8050 3500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 8050 3500 50  0001 C CNN
	4    8050 3500
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8050 3200 8050 2850
Text GLabel 8150 4600 3    50   Input ~ 0
A15
Text GLabel 7950 4600 3    50   Input ~ 0
MEMRQ
Wire Wire Line
	7950 4600 7950 3800
$Comp
L 74xx:74LS14 U?
U 1 1 62615559
P 8150 4200
F 0 "U?" V 8196 4020 50  0000 R CNN
F 1 "74LS14" V 8105 4020 50  0000 R CNN
F 2 "" H 8150 4200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 8150 4200 50  0001 C CNN
	1    8150 4200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8150 3900 8150 3800
Wire Wire Line
	8150 4600 8150 4500
Wire Wire Line
	8150 5300 8150 5900
NoConn ~ 10250 5900
Wire Wire Line
	2550 2200 2550 2000
$Comp
L Device:R R?
U 1 1 6262D0F6
P 2300 2300
F 0 "R?" V 2400 2300 50  0000 C CNN
F 1 "4k7" V 2300 2300 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2230 2300 50  0001 C CNN
F 3 "~" H 2300 2300 50  0001 C CNN
	1    2300 2300
	0    1    1    0   
$EndComp
Connection ~ 2150 2300
Wire Wire Line
	2150 2300 2150 2800
Wire Wire Line
	2450 2300 2550 2300
Wire Wire Line
	2400 2500 2550 2500
Wire Wire Line
	2550 2500 2550 2300
Connection ~ 2550 2300
Wire Wire Line
	2550 2300 2900 2300
Wire Wire Line
	2400 2000 2550 2000
Wire Wire Line
	2100 6550 3000 6550
Wire Wire Line
	2100 7550 3000 7550
Wire Wire Line
	3000 6550 3900 6550
Wire Wire Line
	3000 7550 3900 7550
$EndSCHEMATC
