EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
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
L 74xx:74LS138 U?
U 1 1 62C4D34F
P 2400 1900
F 0 "U?" H 2550 2350 50  0000 C CNN
F 1 "74LS138" V 2400 1850 50  0000 C CNN
F 2 "" H 2400 1900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS138" H 2400 1900 50  0001 C CNN
	1    2400 1900
	1    0    0    -1  
$EndComp
Text GLabel 1900 2300 0    50   Input ~ 0
MEMRQ
Text GLabel 1900 2200 0    50   Input ~ 0
A15
Text GLabel 1900 1800 0    50   Input ~ 0
A14
Text GLabel 1900 2100 0    50   Input ~ 0
A13
Text GLabel 1900 1700 0    50   Input ~ 0
A12
Text GLabel 1900 1600 0    50   Input ~ 0
A11
Text GLabel 3500 1900 2    50   Input ~ 0
VRAMSEL
Text GLabel 3500 1800 2    50   Input ~ 0
CRMASEL
Wire Wire Line
	3500 1800 3350 1800
Wire Wire Line
	3500 1900 3200 1900
$Comp
L Device:R_Small R?
U 1 1 62C4DC63
P 3350 1250
F 0 "R?" H 3291 1204 50  0000 R CNN
F 1 "1k" V 3350 1300 50  0000 R CNN
F 2 "" H 3350 1250 50  0001 C CNN
F 3 "~" H 3350 1250 50  0001 C CNN
	1    3350 1250
	-1   0    0    1   
$EndComp
$Comp
L Device:R_Small R?
U 1 1 62C4DE93
P 3200 1250
F 0 "R?" H 3259 1296 50  0000 L CNN
F 1 "1k" V 3200 1200 50  0000 L CNN
F 2 "" H 3200 1250 50  0001 C CNN
F 3 "~" H 3200 1250 50  0001 C CNN
	1    3200 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 1350 3350 1800
Connection ~ 3350 1800
Wire Wire Line
	3350 1800 2900 1800
Wire Wire Line
	3200 1350 3200 1900
Connection ~ 3200 1900
Wire Wire Line
	3200 1900 2900 1900
Wire Wire Line
	3350 1150 3200 1150
Wire Wire Line
	2400 1150 2400 1300
Connection ~ 3200 1150
Wire Wire Line
	3200 1150 2400 1150
$Comp
L power:+5V #PWR?
U 1 1 62C4E5A3
P 2400 1150
F 0 "#PWR?" H 2400 1000 50  0001 C CNN
F 1 "+5V" H 2415 1323 50  0000 C CNN
F 2 "" H 2400 1150 50  0001 C CNN
F 3 "" H 2400 1150 50  0001 C CNN
	1    2400 1150
	1    0    0    -1  
$EndComp
Connection ~ 2400 1150
$Comp
L Memory_RAM:IDT7132 U?
U 1 1 62C4EA79
P 7050 2300
F 0 "U?" H 7250 3750 50  0000 C CNN
F 1 "IDT7132" H 7050 2950 50  0000 C CNN
F 2 "" H 7050 2300 50  0001 C CNN
F 3 "" H 7050 2300 50  0001 C CNN
	1    7050 2300
	1    0    0    -1  
$EndComp
Text GLabel 7950 1100 2    50   Input ~ 0
CRMASEL
$Comp
L 74xx:74LS241 U?
U 1 1 62C4FD10
P 4950 3300
F 0 "U?" H 4850 3950 50  0000 C CNN
F 1 "74LS241" H 5050 3000 50  0000 C CNN
F 2 "" H 4950 3300 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74ls241.pdf" H 4950 3300 50  0001 C CNN
	1    4950 3300
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6150 2800 5450 2800
Wire Wire Line
	6150 2900 5450 2900
Wire Wire Line
	6150 3000 5450 3000
Wire Wire Line
	6150 3100 5450 3100
Wire Wire Line
	6150 3200 5450 3200
Wire Wire Line
	6150 3300 5450 3300
Wire Wire Line
	6150 3400 5450 3400
Wire Wire Line
	6150 3500 5450 3500
Wire Wire Line
	5450 3700 5450 3750
Text GLabel 5550 3750 2    50   Input ~ 0
VIDEO
Wire Wire Line
	5550 3750 5450 3750
Connection ~ 5450 3750
Wire Wire Line
	5450 3750 5450 3800
Wire Wire Line
	4450 2800 4150 2800
Wire Wire Line
	4150 3200 4450 3200
Wire Wire Line
	4150 2800 4150 3200
Wire Wire Line
	4250 2900 4250 3300
Wire Wire Line
	4250 3300 4450 3300
Wire Wire Line
	4350 3000 4350 3400
Wire Wire Line
	4350 3400 4450 3400
Text GLabel 3800 2800 0    50   Input ~ 0
R
Text GLabel 3800 2900 0    50   Input ~ 0
G
Text GLabel 3800 3000 0    50   Input ~ 0
B
Wire Wire Line
	4150 2800 3800 2800
Connection ~ 4150 2800
Wire Wire Line
	3800 2900 4250 2900
Connection ~ 4250 2900
Wire Wire Line
	4250 2900 4450 2900
Wire Wire Line
	3800 3000 4350 3000
Connection ~ 4350 3000
Wire Wire Line
	4350 3000 4450 3000
NoConn ~ 4450 3100
NoConn ~ 4450 3500
$Comp
L power:GND #PWR?
U 1 1 62C5606A
P 2400 2600
F 0 "#PWR?" H 2400 2350 50  0001 C CNN
F 1 "GND" H 2405 2427 50  0000 C CNN
F 2 "" H 2400 2600 50  0001 C CNN
F 3 "" H 2400 2600 50  0001 C CNN
	1    2400 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 62C56348
P 4950 4100
F 0 "#PWR?" H 4950 3850 50  0001 C CNN
F 1 "GND" H 4955 3927 50  0000 C CNN
F 2 "" H 4950 4100 50  0001 C CNN
F 3 "" H 4950 4100 50  0001 C CNN
	1    4950 4100
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62C568F0
P 4950 2500
F 0 "#PWR?" H 4950 2350 50  0001 C CNN
F 1 "+5V" H 4965 2673 50  0000 C CNN
F 2 "" H 4950 2500 50  0001 C CNN
F 3 "" H 4950 2500 50  0001 C CNN
	1    4950 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 62C572EB
P 7050 3700
F 0 "#PWR?" H 7050 3450 50  0001 C CNN
F 1 "GND" H 7055 3527 50  0000 C CNN
F 2 "" H 7050 3700 50  0001 C CNN
F 3 "" H 7050 3700 50  0001 C CNN
	1    7050 3700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62C57817
P 7050 900
F 0 "#PWR?" H 7050 750 50  0001 C CNN
F 1 "+5V" H 7065 1073 50  0000 C CNN
F 2 "" H 7050 900 50  0001 C CNN
F 3 "" H 7050 900 50  0001 C CNN
	1    7050 900 
	1    0    0    -1  
$EndComp
Text GLabel 7950 1400 2    50   Input ~ 0
RD
Text GLabel 7950 1200 2    50   Input ~ 0
WR
Text GLabel 7950 1600 2    50   Input ~ 0
A0
Text GLabel 7950 1700 2    50   Input ~ 0
A1
Text GLabel 7950 1800 2    50   Input ~ 0
A2
Text GLabel 7950 1900 2    50   Input ~ 0
A3
Text GLabel 7950 2000 2    50   Input ~ 0
A4
Text GLabel 7950 2100 2    50   Input ~ 0
A5
Text GLabel 7950 2200 2    50   Input ~ 0
A6
Text GLabel 7950 2300 2    50   Input ~ 0
A7
Text GLabel 7950 2400 2    50   Input ~ 0
A8
Text GLabel 7950 2500 2    50   Input ~ 0
A9
Text GLabel 7950 2600 2    50   Input ~ 0
A10
Text GLabel 7950 2800 2    50   Input ~ 0
D0
Text GLabel 7950 2900 2    50   Input ~ 0
D1
Text GLabel 7950 3000 2    50   Input ~ 0
D2
Text GLabel 7950 3100 2    50   Input ~ 0
D3
Text GLabel 7950 3200 2    50   Input ~ 0
D4
Text GLabel 7950 3300 2    50   Input ~ 0
D5
Text GLabel 7950 3400 2    50   Input ~ 0
D6
Text GLabel 7950 3500 2    50   Input ~ 0
D7
Text GLabel 6150 1600 0    50   Input ~ 0
h0
Text GLabel 6150 1700 0    50   Input ~ 0
h1
Text GLabel 6150 1800 0    50   Input ~ 0
h2
Text GLabel 6150 1900 0    50   Input ~ 0
h3
Text GLabel 6150 2000 0    50   Input ~ 0
h4
Text GLabel 6150 2100 0    50   Input ~ 0
h5
Text GLabel 6150 2200 0    50   Input ~ 0
v4
Text GLabel 6150 2300 0    50   Input ~ 0
v5
Text GLabel 6150 2400 0    50   Input ~ 0
v6
Text GLabel 6150 2500 0    50   Input ~ 0
v7
Text GLabel 6150 2600 0    50   Input ~ 0
v8
Text GLabel 7950 1300 2    50   Input ~ 0
BUSY
$EndSCHEMATC
