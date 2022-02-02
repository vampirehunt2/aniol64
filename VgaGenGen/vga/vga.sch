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
L 4xxx:4040 U?
U 1 1 61BA4949
P 1800 1750
F 0 "U?" H 1800 2731 50  0000 C CNN
F 1 "4040" H 1800 2640 50  0000 C CNN
F 2 "" H 1800 1750 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 1800 1750 50  0001 C CNN
	1    1800 1750
	-1   0    0    1   
$EndComp
$Comp
L 4xxx:4040 U?
U 1 1 61BA51A9
P 1800 3700
F 0 "U?" H 1800 3500 50  0000 C CNN
F 1 "4040" H 1800 3600 50  0000 C CNN
F 2 "" H 1800 3700 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 1800 3700 50  0001 C CNN
	1    1800 3700
	-1   0    0    1   
$EndComp
$Comp
L Memory_EPROM:27C512 U?
U 1 1 61EB0A99
P 1700 6100
F 0 "U?" H 1700 7381 50  0000 C CNN
F 1 "27C512" H 1700 7290 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 1700 6100 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0015.pdf" H 1700 6100 50  0001 C CNN
	1    1700 6100
	1    0    0    -1  
$EndComp
$Comp
L Oscillator:CXO_DIP14 X25.175MHz
U 1 1 61EB14A1
P 3250 2250
F 0 "X25.175MHz" H 2906 2204 50  0000 R CNN
F 1 "CXO_DIP14" H 2906 2295 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 3700 1900 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 3150 2250 50  0001 C CNN
	1    3250 2250
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2950 2250 2300 2250
Entry Wire Line
	950  1250 1050 1350
Entry Wire Line
	950  1350 1050 1450
Entry Wire Line
	950  1450 1050 1550
Entry Wire Line
	950  1550 1050 1650
Entry Wire Line
	950  1650 1050 1750
Entry Wire Line
	950  1750 1050 1850
Wire Wire Line
	1300 1850 1050 1850
Wire Wire Line
	1300 1750 1050 1750
Wire Wire Line
	1300 1650 1050 1650
Wire Wire Line
	1300 1550 1050 1550
Wire Wire Line
	1300 1450 1050 1450
Wire Wire Line
	1300 1350 1050 1350
Text GLabel 2800 5200 2    50   Input ~ 0
vSync
Text GLabel 2800 5300 2    50   Input ~ 0
hSync
Text GLabel 2800 5400 2    50   Input ~ 0
Blanking
Wire Wire Line
	2800 5400 2100 5400
Wire Wire Line
	2800 5300 2100 5300
Wire Wire Line
	2800 5200 2100 5200
Wire Wire Line
	2100 5500 2500 5500
Wire Wire Line
	2500 5500 2500 1950
Wire Wire Line
	2500 1950 2300 1950
Wire Wire Line
	2100 5600 2400 5600
Wire Wire Line
	2400 5600 2400 3900
Wire Wire Line
	2400 3900 2300 3900
Wire Wire Line
	2100 5700 2300 5700
Wire Wire Line
	2300 5700 2300 4200
Entry Wire Line
	950  3200 1050 3300
Entry Wire Line
	950  3300 1050 3400
Entry Wire Line
	950  3400 1050 3500
Entry Wire Line
	950  3500 1050 3600
Entry Wire Line
	950  3600 1050 3700
Entry Wire Line
	950  3700 1050 3800
Entry Wire Line
	950  3800 1050 3900
Entry Wire Line
	950  3900 1050 4000
Entry Wire Line
	950  4000 1050 4100
Entry Wire Line
	950  4100 1050 4200
Wire Wire Line
	1050 3300 1300 3300
Wire Wire Line
	1050 3400 1300 3400
Wire Wire Line
	1050 3500 1300 3500
Wire Wire Line
	1050 3600 1300 3600
Wire Wire Line
	1050 3700 1300 3700
Wire Wire Line
	1050 3800 1300 3800
Wire Wire Line
	1050 3900 1300 3900
Wire Wire Line
	1050 4000 1300 4000
Wire Wire Line
	1050 4100 1300 4100
Wire Wire Line
	1050 4200 1300 4200
Entry Wire Line
	950  5100 1050 5200
Entry Wire Line
	950  5200 1050 5300
Entry Wire Line
	950  5300 1050 5400
Entry Wire Line
	950  5400 1050 5500
Entry Wire Line
	950  5500 1050 5600
Entry Wire Line
	950  5600 1050 5700
Entry Wire Line
	950  5700 1050 5800
Entry Wire Line
	950  5800 1050 5900
Entry Wire Line
	950  5900 1050 6000
Entry Wire Line
	950  6000 1050 6100
Entry Wire Line
	950  6100 1050 6200
Entry Wire Line
	950  6200 1050 6300
Entry Wire Line
	950  6300 1050 6400
Entry Wire Line
	950  6400 1050 6500
Entry Wire Line
	950  6500 1050 6600
Entry Wire Line
	950  6600 1050 6700
Wire Wire Line
	1300 6700 1050 6700
Wire Wire Line
	1300 6600 1050 6600
Wire Wire Line
	1300 6500 1050 6500
Wire Wire Line
	1300 6400 1050 6400
Wire Wire Line
	1300 6300 1050 6300
Wire Wire Line
	1300 6200 1050 6200
Wire Wire Line
	1300 6100 1050 6100
Wire Wire Line
	1300 6000 1050 6000
Wire Wire Line
	1300 5900 1050 5900
Wire Wire Line
	1300 5800 1050 5800
Wire Wire Line
	1300 5700 1050 5700
Wire Wire Line
	1300 5600 1050 5600
Wire Wire Line
	1300 5500 1050 5500
Wire Wire Line
	1300 5400 1050 5400
Wire Wire Line
	1300 5300 1050 5300
Wire Wire Line
	1300 5200 1050 5200
Wire Wire Line
	1300 6900 1300 7000
Wire Wire Line
	1300 7000 1300 7200
Wire Wire Line
	1300 7200 1700 7200
Connection ~ 1300 7000
$Comp
L power:GND #PWR?
U 1 1 61EDD624
P 1700 7200
F 0 "#PWR?" H 1700 6950 50  0001 C CNN
F 1 "GND" H 1705 7027 50  0000 C CNN
F 2 "" H 1700 7200 50  0001 C CNN
F 3 "" H 1700 7200 50  0001 C CNN
	1    1700 7200
	1    0    0    -1  
$EndComp
Connection ~ 1700 7200
Text Label 1150 1350 0    50   ~ 0
h5
Text Label 1150 1450 0    50   ~ 0
h4
Text Label 1150 1550 0    50   ~ 0
h3
Text Label 1150 1650 0    50   ~ 0
h2
Text Label 1150 1750 0    50   ~ 0
h1
Text Label 1150 1850 0    50   ~ 0
h0
Text Label 1150 3300 0    50   ~ 0
v9
Text Label 1150 3400 0    50   ~ 0
v8
Text Label 1150 3500 0    50   ~ 0
v7
Text Label 1150 3600 0    50   ~ 0
v6
Text Label 1150 3700 0    50   ~ 0
v5
Text Label 1150 3800 0    50   ~ 0
v4
Text Label 1150 3900 0    50   ~ 0
v3
Text Label 1150 4000 0    50   ~ 0
v2
Text Label 1150 4100 0    50   ~ 0
v1
Text Label 1150 4200 0    50   ~ 0
v0
Text Label 1100 5200 0    50   ~ 0
h0
Text Label 1100 5300 0    50   ~ 0
h1
Text Label 1100 5400 0    50   ~ 0
h2
Text Label 1100 5500 0    50   ~ 0
h3
Text Label 1100 5600 0    50   ~ 0
h4
Text Label 1100 5700 0    50   ~ 0
h5
Text Label 1100 5800 0    50   ~ 0
v0
Text Label 1100 5900 0    50   ~ 0
v1
Text Label 1100 6000 0    50   ~ 0
v2
Text Label 1100 6100 0    50   ~ 0
v3
Text Label 1100 6200 0    50   ~ 0
v4
Text Label 1100 6300 0    50   ~ 0
v5
Text Label 1100 6400 0    50   ~ 0
v6
Text Label 1100 6500 0    50   ~ 0
v7
Text Label 1100 6600 0    50   ~ 0
v8
Text Label 1100 6700 0    50   ~ 0
v9
$Comp
L 74xx:74LS165 U?
U 1 1 61EC8A7A
P 6750 4150
F 0 "U?" H 6750 4450 50  0000 C CNN
F 1 "74LS165" V 6750 4150 50  0000 C CNN
F 2 "" H 6750 4150 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74ls165a.pdf" H 6750 4150 50  0001 C CNN
	1    6750 4150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U?
U 1 1 61EC905E
P 8550 4350
F 0 "U?" H 8550 4667 50  0000 C CNN
F 1 "74LS14" H 8550 4576 50  0000 C CNN
F 2 "" H 8550 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 8550 4350 50  0001 C CNN
	1    8550 4350
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS14 U?
U 2 1 61EC9A54
P 9150 4350
F 0 "U?" H 9150 4667 50  0000 C CNN
F 1 "74LS14" H 9150 4576 50  0000 C CNN
F 2 "" H 9150 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 9150 4350 50  0001 C CNN
	2    9150 4350
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS14 U?
U 3 1 61ECADA1
P 10100 1300
F 0 "U?" H 10100 1617 50  0000 C CNN
F 1 "74LS14" H 10100 1526 50  0000 C CNN
F 2 "" H 10100 1300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 10100 1300 50  0001 C CNN
	3    10100 1300
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS14 U?
U 4 1 61ECB5A8
P 4850 4550
F 0 "U?" H 4850 4867 50  0000 C CNN
F 1 "74LS14" H 4850 4776 50  0000 C CNN
F 2 "" H 4850 4550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 4850 4550 50  0001 C CNN
	4    4850 4550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U?
U 1 1 61ECBF3E
P 8850 3400
F 0 "U?" H 8850 3725 50  0000 C CNN
F 1 "74LS08" H 8850 3634 50  0000 C CNN
F 2 "" H 8850 3400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 8850 3400 50  0001 C CNN
	1    8850 3400
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 2 1 61ECD32B
P 9600 3400
F 0 "U?" H 9600 3725 50  0000 C CNN
F 1 "74LS08" H 9600 3634 50  0000 C CNN
F 2 "" H 9600 3400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 9600 3400 50  0001 C CNN
	2    9600 3400
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 3 1 61ECEADE
P 9200 2750
F 0 "U?" H 9200 3075 50  0000 C CNN
F 1 "74LS08" H 9200 2984 50  0000 C CNN
F 2 "" H 9200 2750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 9200 2750 50  0001 C CNN
	3    9200 2750
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 4 1 61ED048C
P 9300 2000
F 0 "U?" H 9300 2325 50  0000 C CNN
F 1 "74LS08" H 9300 2234 50  0000 C CNN
F 2 "" H 9300 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 9300 2000 50  0001 C CNN
	4    9300 2000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9100 3050 8850 3050
Wire Wire Line
	8850 3050 8850 3100
Wire Wire Line
	9300 3050 9600 3050
Wire Wire Line
	9600 3050 9600 3100
Wire Wire Line
	8750 3700 8750 3850
Wire Wire Line
	8750 3850 8550 3850
Wire Wire Line
	8550 3850 8550 4050
Wire Wire Line
	9150 4050 9150 3850
Wire Wire Line
	9150 3850 8950 3850
Wire Wire Line
	8950 3850 8950 3700
Wire Wire Line
	9300 1700 10100 1700
Wire Wire Line
	10100 1700 10100 1600
Wire Wire Line
	9200 2450 9200 2300
Text GLabel 10100 1000 1    50   Input ~ 0
VRAMSEL
Text GLabel 9300 1050 1    50   Input ~ 0
VRAMSEL'
Connection ~ 9300 1700
Text GLabel 9150 4650 3    50   Input ~ 0
A14
Text GLabel 8550 4650 3    50   Input ~ 0
A15
Text GLabel 9500 4650 3    50   Input ~ 0
A13
Text GLabel 9700 4650 3    50   Input ~ 0
A12
Text GLabel 9950 4650 3    50   Input ~ 0
A11
Wire Wire Line
	9500 4650 9500 3700
Wire Wire Line
	9700 3700 9700 4650
Wire Wire Line
	9950 4650 9950 2300
Wire Wire Line
	9400 2300 9950 2300
Wire Wire Line
	10100 1100 10100 1000
Wire Wire Line
	9300 1050 9300 1700
Wire Wire Line
	2800 5800 2100 5800
Text GLabel 2800 5800 2    50   Input ~ 0
TestScreenVideo
Entry Wire Line
	6050 1050 5950 1150
Entry Wire Line
	6050 1150 5950 1250
Entry Wire Line
	6050 1250 5950 1350
Entry Wire Line
	6050 1350 5950 1450
Entry Wire Line
	6050 1450 5950 1550
Entry Wire Line
	6050 1550 5950 1650
Entry Wire Line
	6050 1650 5950 1750
Entry Wire Line
	6050 1750 5950 1850
Wire Wire Line
	5950 1850 5850 1850
Wire Wire Line
	5950 1750 5850 1750
Wire Wire Line
	5950 1650 5850 1650
Wire Wire Line
	5950 1550 5850 1550
Wire Wire Line
	5950 1450 5850 1450
Wire Wire Line
	5950 1350 5850 1350
Wire Wire Line
	5950 1250 5850 1250
Wire Wire Line
	5950 1150 5850 1150
Entry Wire Line
	6050 4450 6150 4350
Entry Wire Line
	6050 4350 6150 4250
Entry Wire Line
	6050 4250 6150 4150
Entry Wire Line
	6050 4150 6150 4050
Entry Wire Line
	6050 4050 6150 3950
Entry Wire Line
	6050 3950 6150 3850
Entry Wire Line
	6050 3850 6150 3750
Entry Wire Line
	6050 3750 6150 3650
Wire Wire Line
	6250 3650 6150 3650
Wire Wire Line
	6250 3750 6150 3750
Wire Wire Line
	6250 3850 6150 3850
Wire Wire Line
	6250 3950 6150 3950
Wire Wire Line
	6250 4050 6150 4050
Wire Wire Line
	6250 4150 6150 4150
Wire Wire Line
	6250 4250 6150 4250
Wire Wire Line
	6250 4350 6150 4350
Wire Wire Line
	6250 4850 6250 5150
Wire Wire Line
	6250 5150 6750 5150
Wire Wire Line
	5150 4550 6250 4550
$Comp
L Device:C C?
U 1 1 61F61758
P 4350 4550
F 0 "C?" V 4602 4550 50  0000 C CNN
F 1 "C" V 4511 4550 50  0000 C CNN
F 2 "" H 4388 4400 50  0001 C CNN
F 3 "~" H 4350 4550 50  0001 C CNN
	1    4350 4550
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 61F62539
P 4550 4850
F 0 "R?" H 4620 4896 50  0000 L CNN
F 1 "R" H 4620 4805 50  0000 L CNN
F 2 "" V 4480 4850 50  0001 C CNN
F 3 "~" H 4550 4850 50  0001 C CNN
	1    4550 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 4550 4550 4550
Wire Wire Line
	4550 4550 4550 4700
Connection ~ 4550 4550
Wire Wire Line
	4550 5000 4550 5200
$Comp
L power:GND #PWR?
U 1 1 61F6C1A7
P 4550 5200
F 0 "#PWR?" H 4550 4950 50  0001 C CNN
F 1 "GND" H 4555 5027 50  0000 C CNN
F 2 "" H 4550 5200 50  0001 C CNN
F 3 "" H 4550 5200 50  0001 C CNN
	1    4550 5200
	1    0    0    -1  
$EndComp
Entry Wire Line
	950  4450 1050 4550
Wire Wire Line
	4200 4550 1050 4550
Text Label 1050 4550 0    50   ~ 0
h0
$Comp
L Memory_EEPROM:28C256 U?
U 1 1 61FAAC9C
P 5450 2050
F 0 "U?" H 5450 2350 50  0000 C CNN
F 1 "28C256" V 5450 2050 50  0000 C CNN
F 2 "" H 5450 2050 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 5450 2050 50  0001 C CNN
	1    5450 2050
	1    0    0    -1  
$EndComp
Text GLabel 7250 3550 2    50   Input ~ 0
Video
NoConn ~ 7250 3650
NoConn ~ 6250 3550
Text GLabel 1300 2450 3    50   Input ~ 0
PixelClock
Wire Wire Line
	1300 2450 1300 2250
Text GLabel 6250 4750 0    50   Input ~ 0
PixelClock
Wire Bus Line
	950  700  4700 700 
Wire Wire Line
	5050 3150 5450 3150
Wire Wire Line
	5050 2950 5050 3150
$Comp
L power:GND #PWR?
U 1 1 61FC32A6
P 5450 3150
F 0 "#PWR?" H 5450 2900 50  0001 C CNN
F 1 "GND" H 5455 2977 50  0000 C CNN
F 2 "" H 5450 3150 50  0001 C CNN
F 3 "" H 5450 3150 50  0001 C CNN
	1    5450 3150
	1    0    0    -1  
$EndComp
Connection ~ 5450 3150
Connection ~ 5050 2950
Wire Wire Line
	5050 2850 5050 2950
$Comp
L power:+5V #PWR?
U 1 1 61FC442F
P 5450 950
F 0 "#PWR?" H 5450 800 50  0001 C CNN
F 1 "+5V" H 5465 1123 50  0000 C CNN
F 2 "" H 5450 950 50  0001 C CNN
F 3 "" H 5450 950 50  0001 C CNN
	1    5450 950 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61FC4AAE
P 4950 2750
F 0 "#PWR?" H 4950 2600 50  0001 C CNN
F 1 "+5V" H 4850 2750 50  0000 C CNN
F 2 "" H 4950 2750 50  0001 C CNN
F 3 "" H 4950 2750 50  0001 C CNN
	1    4950 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 2750 4950 2750
Entry Wire Line
	950  1850 1050 1950
Entry Wire Line
	950  1950 1050 2050
Entry Wire Line
	950  2050 1050 2150
Wire Wire Line
	1300 2150 1050 2150
Wire Wire Line
	1300 2050 1050 2050
Wire Wire Line
	1300 1950 1050 1950
Entry Wire Line
	4700 1050 4800 1150
Entry Wire Line
	4700 1150 4800 1250
Entry Wire Line
	4700 1250 4800 1350
Entry Wire Line
	4700 1350 4800 1450
Entry Wire Line
	4700 1450 4800 1550
Entry Wire Line
	4700 1550 4800 1650
Entry Wire Line
	4700 1650 4800 1750
Entry Wire Line
	4700 1750 4800 1850
Entry Wire Line
	4700 1850 4800 1950
Entry Wire Line
	4700 1950 4800 2050
Entry Wire Line
	4700 2050 4800 2150
Entry Wire Line
	4700 2150 4800 2250
Entry Wire Line
	4700 2250 4800 2350
Entry Wire Line
	4700 2350 4800 2450
Wire Wire Line
	5050 2450 4800 2450
Wire Wire Line
	5050 2350 4800 2350
Wire Wire Line
	5050 2250 4800 2250
Wire Wire Line
	5050 2150 4800 2150
Wire Wire Line
	5050 2050 4800 2050
Wire Wire Line
	5050 1950 4800 1950
Wire Wire Line
	5050 1850 4800 1850
Wire Wire Line
	5050 1750 4800 1750
Wire Wire Line
	5050 1650 4800 1650
Wire Wire Line
	5050 1550 4800 1550
Wire Wire Line
	5050 1450 4800 1450
Wire Wire Line
	5050 1350 4800 1350
Wire Wire Line
	5050 1250 4800 1250
Wire Wire Line
	5050 1150 4800 1150
Text Label 1150 1950 0    50   ~ 0
Px2
Text Label 1150 2050 0    50   ~ 0
Px1
Text Label 1150 2150 0    50   ~ 0
Px0
Text Label 4850 1150 0    50   ~ 0
Px0
Text Label 4850 1250 0    50   ~ 0
Px1
Text Label 4850 1350 0    50   ~ 0
Px2
Text Label 4850 1450 0    50   ~ 0
h0
Text Label 4850 1550 0    50   ~ 0
h1
Text Label 4850 1650 0    50   ~ 0
h2
Text Label 4850 1750 0    50   ~ 0
h3
Text Label 4850 1850 0    50   ~ 0
h4
Text Label 4850 1950 0    50   ~ 0
h5
Text Label 4850 2050 0    50   ~ 0
v1
Text Label 4850 2150 0    50   ~ 0
v2
Text Label 4850 2250 0    50   ~ 0
v3
Text Label 4850 2350 0    50   ~ 0
v4
Text Label 4850 2450 0    50   ~ 0
v5
NoConn ~ 5050 2550
NoConn ~ 1300 3100
NoConn ~ 1300 3200
NoConn ~ 1300 1150
NoConn ~ 1300 1250
Wire Bus Line
	6050 1050 6050 4450
Wire Bus Line
	4700 700  4700 2550
Wire Bus Line
	950  700  950  6700
$Comp
L power:GND #PWR?
U 1 1 62070222
P 3250 2550
F 0 "#PWR?" H 3250 2300 50  0001 C CNN
F 1 "GND" H 3255 2377 50  0000 C CNN
F 2 "" H 3250 2550 50  0001 C CNN
F 3 "" H 3250 2550 50  0001 C CNN
	1    3250 2550
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 6207080C
P 3250 1950
F 0 "#PWR?" H 3250 1800 50  0001 C CNN
F 1 "+5V" H 3265 2123 50  0000 C CNN
F 2 "" H 3250 1950 50  0001 C CNN
F 3 "" H 3250 1950 50  0001 C CNN
	1    3250 1950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 62070E16
P 6750 5150
F 0 "#PWR?" H 6750 4900 50  0001 C CNN
F 1 "GND" H 6755 4977 50  0000 C CNN
F 2 "" H 6750 5150 50  0001 C CNN
F 3 "" H 6750 5150 50  0001 C CNN
	1    6750 5150
	1    0    0    -1  
$EndComp
Connection ~ 6750 5150
$Comp
L power:+5V #PWR?
U 1 1 620715ED
P 6750 3250
F 0 "#PWR?" H 6750 3100 50  0001 C CNN
F 1 "+5V" H 6765 3423 50  0000 C CNN
F 2 "" H 6750 3250 50  0001 C CNN
F 3 "" H 6750 3250 50  0001 C CNN
	1    6750 3250
	1    0    0    -1  
$EndComp
$EndSCHEMATC
