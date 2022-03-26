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
L 4xxx:4040 X
U 1 1 61BA4949
P 1800 1750
F 0 "X" H 1750 1550 50  0000 C CNN
F 1 "4040" H 1700 1400 50  0000 C CNN
F 2 "" H 1800 1750 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 1800 1750 50  0001 C CNN
	1    1800 1750
	-1   0    0    1   
$EndComp
$Comp
L 4xxx:4040 Y
U 1 1 61BA51A9
P 1800 3700
F 0 "Y" H 1700 3500 50  0000 C CNN
F 1 "4040" H 1700 3350 50  0000 C CNN
F 2 "" H 1800 3700 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 1800 3700 50  0001 C CNN
	1    1800 3700
	-1   0    0    1   
$EndComp
$Comp
L Memory_EPROM:27C512 VGAGEN
U 1 1 61EB0A99
P 1700 6100
F 0 "VGAGEN" V 1700 6100 50  0000 C CNN
F 1 "27C512" V 1700 5650 50  0000 C CNN
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
	2800 5200 2700 5200
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
P 5350 5700
F 0 "U?" H 5350 6000 50  0000 C CNN
F 1 "74LS165" V 5350 5700 50  0000 C CNN
F 2 "" H 5350 5700 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74ls165a.pdf" H 5350 5700 50  0001 C CNN
	1    5350 5700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U?
U 4 1 61ECB5A8
P 3800 4550
F 0 "U?" H 3800 4867 50  0000 C CNN
F 1 "74LS14" H 3800 4776 50  0000 C CNN
F 2 "" H 3800 4550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 3800 4550 50  0001 C CNN
	4    3800 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 5800 2100 5800
Text GLabel 2800 5800 2    50   Input ~ 0
TestScreenVideo
Entry Wire Line
	4750 5900 4650 5800
Entry Wire Line
	4750 5800 4650 5700
Entry Wire Line
	4750 5700 4650 5600
Entry Wire Line
	4750 5600 4650 5500
Entry Wire Line
	4750 5500 4650 5400
Entry Wire Line
	4750 5400 4650 5300
Entry Wire Line
	4750 5300 4650 5200
Entry Wire Line
	4750 5200 4650 5100
Wire Wire Line
	4850 5200 4750 5200
Wire Wire Line
	4850 5300 4750 5300
Wire Wire Line
	4850 5400 4750 5400
Wire Wire Line
	4850 5500 4750 5500
Wire Wire Line
	4850 5600 4750 5600
Wire Wire Line
	4850 5700 4750 5700
Wire Wire Line
	4850 5800 4750 5800
Wire Wire Line
	4850 5900 4750 5900
Wire Wire Line
	4850 6400 4850 6700
Wire Wire Line
	4850 6700 5350 6700
$Comp
L Device:C C?
U 1 1 61F61758
P 3300 4550
F 0 "C?" V 3552 4550 50  0000 C CNN
F 1 "18p" V 3461 4550 50  0000 C CNN
F 2 "" H 3338 4400 50  0001 C CNN
F 3 "~" H 3300 4550 50  0001 C CNN
	1    3300 4550
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 61F62539
P 3500 4850
F 0 "R?" H 3570 4896 50  0000 L CNN
F 1 "1k" H 3570 4805 50  0000 L CNN
F 2 "" V 3430 4850 50  0001 C CNN
F 3 "~" H 3500 4850 50  0001 C CNN
	1    3500 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 4550 3500 4550
Wire Wire Line
	3500 4550 3500 4700
Connection ~ 3500 4550
Wire Wire Line
	3500 5000 3500 5200
$Comp
L power:GND #PWR?
U 1 1 61F6C1A7
P 3500 5200
F 0 "#PWR?" H 3500 4950 50  0001 C CNN
F 1 "GND" H 3505 5027 50  0000 C CNN
F 2 "" H 3500 5200 50  0001 C CNN
F 3 "" H 3500 5200 50  0001 C CNN
	1    3500 5200
	1    0    0    -1  
$EndComp
Entry Wire Line
	950  4450 1050 4550
Text GLabel 5850 5100 2    50   Input ~ 0
Video
NoConn ~ 5850 5200
Text GLabel 1300 2450 3    50   Input ~ 0
PixelClock
Wire Wire Line
	1300 2450 1300 2250
Text GLabel 4850 6300 0    50   Input ~ 0
PixelClock
Entry Wire Line
	7950 1350 8050 1450
Entry Wire Line
	7950 1450 8050 1550
Entry Wire Line
	7950 1550 8050 1650
Entry Wire Line
	7950 1650 8050 1750
Entry Wire Line
	7950 1750 8050 1850
Entry Wire Line
	7950 1850 8050 1950
Entry Wire Line
	7950 1950 8050 2050
Entry Wire Line
	7950 2050 8050 2150
Entry Wire Line
	7950 2150 8050 2250
Entry Wire Line
	7950 2250 8050 2350
Entry Wire Line
	7950 2350 8050 2450
Wire Wire Line
	8300 2450 8050 2450
Wire Wire Line
	8300 2350 8050 2350
Wire Wire Line
	8300 2250 8050 2250
Wire Wire Line
	8300 2150 8050 2150
Wire Wire Line
	8300 2050 8050 2050
Wire Wire Line
	8300 1950 8050 1950
Wire Wire Line
	8300 1850 8050 1850
Wire Wire Line
	8300 1750 8050 1750
Wire Wire Line
	8300 1650 8050 1650
Wire Wire Line
	8300 1550 8050 1550
Wire Wire Line
	8300 1450 8050 1450
Text Label 8100 1450 0    50   ~ 0
h0
Text Label 8100 1550 0    50   ~ 0
h1
Text Label 8100 1650 0    50   ~ 0
h2
Text Label 8100 1750 0    50   ~ 0
h3
Text Label 8100 1850 0    50   ~ 0
h4
Text Label 8100 1950 0    50   ~ 0
h5
Text Label 8100 2050 0    50   ~ 0
v4
Text Label 8100 2150 0    50   ~ 0
v5
Text Label 8100 2250 0    50   ~ 0
v6
Text Label 8100 2350 0    50   ~ 0
v7
Text Label 8100 2450 0    50   ~ 0
v8
NoConn ~ 1300 3100
NoConn ~ 1300 3200
NoConn ~ 1300 1150
NoConn ~ 1300 1250
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
P 5350 6700
F 0 "#PWR?" H 5350 6450 50  0001 C CNN
F 1 "GND" H 5355 6527 50  0000 C CNN
F 2 "" H 5350 6700 50  0001 C CNN
F 3 "" H 5350 6700 50  0001 C CNN
	1    5350 6700
	1    0    0    -1  
$EndComp
Connection ~ 5350 6700
$Comp
L power:+5V #PWR?
U 1 1 620715ED
P 5350 4800
F 0 "#PWR?" H 5350 4650 50  0001 C CNN
F 1 "+5V" H 5365 4973 50  0000 C CNN
F 2 "" H 5350 4800 50  0001 C CNN
F 3 "" H 5350 4800 50  0001 C CNN
	1    5350 4800
	1    0    0    -1  
$EndComp
$Comp
L Memory_RAM:IDT7132 VRAM
U 1 1 620FDA08
P 9200 2150
F 0 "VRAM" H 9200 2200 50  0000 C CNN
F 1 "IDT7132" H 9150 1850 50  0000 C CNN
F 2 "" H 9200 2150 50  0001 C CNN
F 3 "" H 9200 2150 50  0001 C CNN
	1    9200 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1050 4550 3150 4550
Text GLabel 10750 1150 2    50   Input ~ 0
WAIT
Text GLabel 7400 950  0    50   Input ~ 0
Blanking
Text GLabel 10600 950  2    50   Input ~ 0
VRAMSEL
Text GLabel 10100 1450 2    50   Input ~ 0
A0
Text GLabel 10100 1550 2    50   Input ~ 0
A1
Text GLabel 10100 1650 2    50   Input ~ 0
A2
Text GLabel 10100 1750 2    50   Input ~ 0
A3
Text GLabel 10100 1850 2    50   Input ~ 0
A4
Text GLabel 10100 1950 2    50   Input ~ 0
A5
Text GLabel 10100 2050 2    50   Input ~ 0
A6
Text GLabel 10100 2150 2    50   Input ~ 0
A7
Text GLabel 10100 2250 2    50   Input ~ 0
A8
Text GLabel 10100 2350 2    50   Input ~ 0
A9
Text GLabel 10100 2450 2    50   Input ~ 0
A10
Text GLabel 10100 2650 2    50   Input ~ 0
D7
Text GLabel 10100 2750 2    50   Input ~ 0
D6
Text GLabel 10100 2850 2    50   Input ~ 0
D5
Text GLabel 10100 2950 2    50   Input ~ 0
D4
Text GLabel 10100 3050 2    50   Input ~ 0
D3
Text GLabel 10100 3150 2    50   Input ~ 0
D2
Text GLabel 10100 3250 2    50   Input ~ 0
D1
Text GLabel 10100 3350 2    50   Input ~ 0
D0
$Comp
L power:GND #PWR?
U 1 1 6215C42E
P 9200 3550
F 0 "#PWR?" H 9200 3300 50  0001 C CNN
F 1 "GND" H 9205 3377 50  0000 C CNN
F 2 "" H 9200 3550 50  0001 C CNN
F 3 "" H 9200 3550 50  0001 C CNN
	1    9200 3550
	1    0    0    -1  
$EndComp
NoConn ~ 1300 2050
NoConn ~ 1300 2150
$Comp
L power:+5V #PWR?
U 1 1 62165167
P 9200 750
F 0 "#PWR?" H 9200 600 50  0001 C CNN
F 1 "+5V" H 9215 923 50  0000 C CNN
F 2 "" H 9200 750 50  0001 C CNN
F 3 "" H 9200 750 50  0001 C CNN
	1    9200 750 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 62165662
P 8100 700
F 0 "#PWR?" H 8100 550 50  0001 C CNN
F 1 "+5V" H 8115 873 50  0000 C CNN
F 2 "" H 8100 700 50  0001 C CNN
F 3 "" H 8100 700 50  0001 C CNN
	1    8100 700 
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 700  8100 1050
NoConn ~ 8300 1150
Text GLabel 10100 1250 2    50   Input ~ 0
RD
Text GLabel 10100 1050 2    50   Input ~ 0
WR
Wire Wire Line
	8300 950  8200 950 
Wire Wire Line
	8300 1250 8200 1250
Connection ~ 8200 950 
Wire Wire Line
	8200 950  7400 950 
Wire Wire Line
	8200 1250 8200 950 
Wire Wire Line
	8100 1050 8300 1050
Entry Wire Line
	6100 1650 6000 1550
Entry Wire Line
	6100 1750 6000 1650
Entry Wire Line
	6100 1850 6000 1750
Entry Wire Line
	6100 1950 6000 1850
Entry Wire Line
	6100 2050 6000 1950
Entry Wire Line
	6100 2150 6000 2050
Entry Wire Line
	6100 2250 6000 2150
Entry Wire Line
	6100 2350 6000 2250
Wire Wire Line
	6000 1550 5700 1550
Wire Wire Line
	6000 1650 5700 1650
Wire Wire Line
	6000 1750 5700 1750
Wire Wire Line
	6000 1850 5700 1850
Wire Wire Line
	6000 1950 5700 1950
Wire Wire Line
	6000 2050 5700 2050
Wire Wire Line
	6000 2150 5700 2150
Wire Wire Line
	6000 2250 5700 2250
Text Label 5800 1850 0    50   ~ 0
ch3
Text Label 5800 1950 0    50   ~ 0
ch4
Text Label 5800 2050 0    50   ~ 0
ch5
Text Label 5800 2150 0    50   ~ 0
ch6
Text Label 5800 2250 0    50   ~ 0
ch7
Text Label 5800 1750 0    50   ~ 0
ch2
Text Label 5800 1650 0    50   ~ 0
ch1
Text Label 5800 1550 0    50   ~ 0
ch0
Wire Wire Line
	4850 5100 4850 4750
$Comp
L power:GND #PWR?
U 1 1 621CE7F4
P 4850 4750
F 0 "#PWR?" H 4850 4500 50  0001 C CNN
F 1 "GND" H 4855 4577 50  0000 C CNN
F 2 "" H 4850 4750 50  0001 C CNN
F 3 "" H 4850 4750 50  0001 C CNN
	1    4850 4750
	-1   0    0    1   
$EndComp
Text Label 4750 5200 0    50   ~ 0
ch0
Text Label 4750 5300 0    50   ~ 0
ch1
Text Label 4750 5400 0    50   ~ 0
ch2
Text Label 4750 5500 0    50   ~ 0
ch3
Text Label 4750 5600 0    50   ~ 0
ch4
Text Label 4750 5700 0    50   ~ 0
ch5
Text Label 4750 5800 0    50   ~ 0
ch6
Text Label 4750 5900 0    50   ~ 0
ch7
Entry Wire Line
	7950 2550 8050 2650
Entry Wire Line
	7950 2650 8050 2750
Entry Wire Line
	7950 2750 8050 2850
Entry Wire Line
	7950 2850 8050 2950
Entry Wire Line
	7950 2950 8050 3050
Entry Wire Line
	7950 3050 8050 3150
Entry Wire Line
	7950 3150 8050 3250
Entry Wire Line
	7950 3250 8050 3350
Wire Wire Line
	8300 3350 8050 3350
Wire Wire Line
	8300 3250 8050 3250
Wire Wire Line
	8300 3150 8050 3150
Wire Wire Line
	8300 3050 8050 3050
Wire Wire Line
	8300 2950 8050 2950
Wire Wire Line
	8300 2850 8050 2850
Wire Wire Line
	8300 2750 8050 2750
Wire Wire Line
	8300 2650 8050 2650
Entry Wire Line
	4300 1450 4400 1550
Entry Wire Line
	4300 1550 4400 1650
Entry Wire Line
	4300 1650 4400 1750
Entry Wire Line
	4300 1750 4400 1850
Entry Wire Line
	4300 1850 4400 1950
Entry Wire Line
	4300 1950 4400 2050
Entry Wire Line
	4300 2050 4400 2150
Entry Wire Line
	4300 2150 4400 2250
Entry Wire Line
	4300 2250 4400 2350
Entry Wire Line
	4300 2350 4400 2450
Entry Wire Line
	4300 2450 4400 2550
Wire Wire Line
	4900 1550 4400 1550
Wire Wire Line
	4900 1650 4400 1650
Wire Wire Line
	4900 1750 4400 1750
Wire Wire Line
	4900 1850 4400 1850
Wire Wire Line
	4900 1950 4400 1950
Wire Wire Line
	4900 2050 4400 2050
Wire Wire Line
	4900 2150 4400 2150
Wire Wire Line
	4900 2250 4400 2250
Wire Wire Line
	4900 2350 4400 2350
Wire Wire Line
	4900 2450 4400 2450
Wire Wire Line
	4900 2550 4400 2550
Wire Wire Line
	5300 3550 5300 3700
Connection ~ 5300 3700
Wire Wire Line
	5300 3700 5300 3850
Wire Wire Line
	4900 2950 4800 2950
$Comp
L power:+5V #PWR?
U 1 1 62283722
P 5300 1350
F 0 "#PWR?" H 5300 1200 50  0001 C CNN
F 1 "+5V" H 5315 1523 50  0000 C CNN
F 2 "" H 5300 1350 50  0001 C CNN
F 3 "" H 5300 1350 50  0001 C CNN
	1    5300 1350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 62283CA5
P 5300 3850
F 0 "#PWR?" H 5300 3600 50  0001 C CNN
F 1 "GND" H 5305 3677 50  0000 C CNN
F 2 "" H 5300 3850 50  0001 C CNN
F 3 "" H 5300 3850 50  0001 C CNN
	1    5300 3850
	1    0    0    -1  
$EndComp
Text Label 4400 1550 0    50   ~ 0
v1
Text Label 4400 1650 0    50   ~ 0
v2
Text Label 4400 1750 0    50   ~ 0
v3
Text Label 4400 1850 0    50   ~ 0
asc0
Text Label 4400 1950 0    50   ~ 0
asc1
Text Label 4400 2050 0    50   ~ 0
asc2
Text Label 4400 2150 0    50   ~ 0
asc3
Text Label 4400 2250 0    50   ~ 0
asc4
Text Label 4400 2350 0    50   ~ 0
asc5
Text Label 4400 2450 0    50   ~ 0
asc6
Text Label 4400 2550 0    50   ~ 0
asc7
Text Label 8050 2650 0    50   ~ 0
asc0
Text Label 8050 2750 0    50   ~ 0
asc1
Text Label 8050 2850 0    50   ~ 0
asc2
Text Label 8050 2950 0    50   ~ 0
asc3
Text Label 8050 3050 0    50   ~ 0
asc4
Text Label 8050 3150 0    50   ~ 0
asc5
Text Label 8050 3250 0    50   ~ 0
asc6
Text Label 8050 3350 0    50   ~ 0
asc7
Text GLabel 2850 5000 2    50   Input ~ 0
NMI
Wire Wire Line
	2850 5000 2700 5000
Wire Wire Line
	2700 5000 2700 5200
Connection ~ 2700 5200
Wire Wire Line
	2700 5200 2100 5200
Wire Bus Line
	6100 4250 4650 4250
Wire Wire Line
	4850 6100 4100 6100
Wire Wire Line
	4100 4550 4100 6100
$Comp
L 74xx:74LS14 U?
U 1 1 6216906C
P 7850 4500
F 0 "U?" H 7850 4817 50  0000 C CNN
F 1 "74LS14" H 7850 4726 50  0000 C CNN
F 2 "" H 7850 4500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 7850 4500 50  0001 C CNN
	1    7850 4500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U?
U 2 1 62169072
P 7850 5000
F 0 "U?" H 7850 5317 50  0000 C CNN
F 1 "74LS14" H 7850 5226 50  0000 C CNN
F 2 "" H 7850 5000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 7850 5000 50  0001 C CNN
	2    7850 5000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U?
U 3 1 62169078
P 9550 5800
F 0 "U?" H 9550 6117 50  0000 C CNN
F 1 "74LS14" H 9550 6026 50  0000 C CNN
F 2 "" H 9550 5800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 9550 5800 50  0001 C CNN
	3    9550 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9150 5000 9150 5800
Wire Wire Line
	9150 5800 9250 5800
Text GLabel 9850 5800 2    50   Input ~ 0
VRAMSEL
Text GLabel 9800 5000 2    50   Input ~ 0
VRAMSEL'
Text GLabel 7550 5000 0    50   Input ~ 0
A14
Text GLabel 7550 4500 0    50   Input ~ 0
A15
Text GLabel 8350 5100 0    50   Input ~ 0
A13
Text GLabel 8350 5200 0    50   Input ~ 0
A12
Text GLabel 8350 5300 0    50   Input ~ 0
A11
Wire Wire Line
	9750 5800 9850 5800
Wire Wire Line
	9800 5000 9150 5000
Wire Bus Line
	950  700  4300 700 
Connection ~ 4300 700 
Wire Bus Line
	4300 700  7950 700 
$Comp
L power:GND #PWR?
U 1 1 621A76DC
P 3500 3400
F 0 "#PWR?" H 3500 3150 50  0001 C CNN
F 1 "GND" H 3505 3227 50  0000 C CNN
F 2 "" H 3500 3400 50  0001 C CNN
F 3 "" H 3500 3400 50  0001 C CNN
	1    3500 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 2750 4600 2750
Wire Wire Line
	4900 2650 4500 2650
$Comp
L Device:R_Small R?
U 1 1 621C1552
P 4100 2900
F 0 "R?" H 4050 2500 50  0000 L CNN
F 1 "4k7" H 4000 2400 50  0000 L CNN
F 2 "" H 4100 2900 50  0001 C CNN
F 3 "~" H 4100 2900 50  0001 C CNN
	1    4100 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 621C1E6D
P 4200 2900
F 0 "R?" H 4150 2500 50  0000 L CNN
F 1 "4k7" H 4150 2400 50  0000 L CNN
F 2 "" H 4200 2900 50  0001 C CNN
F 3 "~" H 4200 2900 50  0001 C CNN
	1    4200 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 3000 4200 3150
Connection ~ 4200 3150
Wire Wire Line
	4200 3150 4100 3150
Wire Wire Line
	4100 3000 4100 3050
Wire Wire Line
	4200 2800 4100 2800
$Comp
L power:+5V #PWR?
U 1 1 621DD412
P 4100 2700
F 0 "#PWR?" H 4100 2550 50  0001 C CNN
F 1 "+5V" H 4115 2873 50  0000 C CNN
F 2 "" H 4100 2700 50  0001 C CNN
F 3 "" H 4100 2700 50  0001 C CNN
	1    4100 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 2700 4100 2800
Connection ~ 4100 2800
$Comp
L power:+5V #PWR?
U 1 1 622602D6
P 10900 700
F 0 "#PWR?" H 10900 550 50  0001 C CNN
F 1 "+5V" H 10915 873 50  0000 C CNN
F 2 "" H 10900 700 50  0001 C CNN
F 3 "" H 10900 700 50  0001 C CNN
	1    10900 700 
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 62260EEC
P 10450 800
F 0 "R?" V 10254 800 50  0000 C CNN
F 1 "R_Small" V 10345 800 50  0000 C CNN
F 2 "" H 10450 800 50  0001 C CNN
F 3 "~" H 10450 800 50  0001 C CNN
	1    10450 800 
	0    1    1    0   
$EndComp
Connection ~ 10100 950 
$Comp
L Device:D_Schottky D?
U 1 1 6227D84D
P 10450 1150
F 0 "D?" H 10600 1200 50  0000 C CNN
F 1 "D_Schottky" H 10550 1050 50  0000 C CNN
F 2 "" H 10450 1150 50  0001 C CNN
F 3 "~" H 10450 1150 50  0001 C CNN
	1    10450 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	10600 1150 10750 1150
Wire Wire Line
	10300 1150 10100 1150
Wire Wire Line
	10100 950  10600 950 
Wire Wire Line
	10350 800  10100 800 
Wire Wire Line
	10100 800  10100 950 
Wire Wire Line
	10550 800  10900 800 
Wire Wire Line
	10900 800  10900 700 
$Comp
L 74xx:74LS30 U?
U 1 1 623C44D8
P 8850 5000
F 0 "U?" H 8850 5525 50  0000 C CNN
F 1 "74LS30" H 8850 5434 50  0000 C CNN
F 2 "" H 8850 5000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS30" H 8850 5000 50  0001 C CNN
	1    8850 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	8350 5100 8550 5100
Wire Wire Line
	8350 5200 8550 5200
Wire Wire Line
	8350 5300 8550 5300
Wire Wire Line
	8550 5000 8150 5000
Wire Wire Line
	8550 4900 8150 4900
Wire Wire Line
	8150 4900 8150 4500
$Comp
L power:+5V #PWR?
U 1 1 62458EBA
P 8550 4450
F 0 "#PWR?" H 8550 4300 50  0001 C CNN
F 1 "+5V" H 8565 4623 50  0000 C CNN
F 2 "" H 8550 4450 50  0001 C CNN
F 3 "" H 8550 4450 50  0001 C CNN
	1    8550 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8550 4450 8550 4700
Connection ~ 8550 4700
Wire Wire Line
	8550 4700 8550 4800
Connection ~ 9150 5000
Text GLabel 7350 5400 0    50   Input ~ 0
MEMRQ
$Comp
L Switch:SW_DIP_x03 SW?
U 1 1 623E144D
P 3800 3250
F 0 "SW?" H 3800 3717 50  0000 C CNN
F 1 "SW_DIP_x03" H 3800 3626 50  0000 C CNN
F 2 "" H 3800 3250 50  0001 C CNN
F 3 "~" H 3800 3250 50  0001 C CNN
	1    3800 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 3250 3500 3400
Connection ~ 4100 3050
Wire Wire Line
	3500 3050 3500 3150
Connection ~ 3500 3250
Connection ~ 3500 3150
Wire Wire Line
	3500 3150 3500 3250
Wire Wire Line
	4800 2950 4800 3150
Wire Wire Line
	4800 3700 5300 3700
$Comp
L Memory_EPROM:27C256 CharROM
U 1 1 62173F7D
P 5300 2450
F 0 "CharROM" V 5300 2950 50  0000 C CNN
F 1 "27C256" V 5300 2100 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 5300 2450 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0014.pdf" H 5300 2450 50  0001 C CNN
	1    5300 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 3150 4800 3150
Connection ~ 4800 3150
Wire Wire Line
	4800 3150 4800 3250
Wire Wire Line
	4900 3250 4800 3250
Connection ~ 4800 3250
Wire Wire Line
	4800 3250 4800 3350
Wire Wire Line
	4900 3350 4800 3350
Connection ~ 4800 3350
Wire Wire Line
	4800 3350 4800 3700
Entry Wire Line
	950  1850 1050 1950
Wire Wire Line
	1300 1950 1050 1950
Text Label 1050 1950 0    50   ~ 0
load
Text Label 1050 4550 0    50   ~ 0
load
$Comp
L 74xx:74LS14 U?
U 3 1 6243E887
P 7650 5400
F 0 "U?" H 7650 5717 50  0000 C CNN
F 1 "74LS14" H 7650 5626 50  0000 C CNN
F 2 "" H 7650 5400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 7650 5400 50  0001 C CNN
	3    7650 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 5400 8550 5400
Wire Wire Line
	4700 2850 4700 3250
Wire Wire Line
	4700 2850 4900 2850
Wire Wire Line
	4100 3250 4300 3250
Wire Wire Line
	4600 3150 4600 2750
Wire Wire Line
	4200 3150 4600 3150
Wire Wire Line
	4500 3050 4500 2650
Wire Wire Line
	4100 3050 4500 3050
$Comp
L Device:R_Small R?
U 1 1 62465F54
P 4300 2900
F 0 "R?" H 4359 2946 50  0000 L CNN
F 1 "R_Small" H 4359 2855 50  0000 L CNN
F 2 "" H 4300 2900 50  0001 C CNN
F 3 "~" H 4300 2900 50  0001 C CNN
	1    4300 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 2800 4200 2800
Connection ~ 4200 2800
Wire Wire Line
	4300 3000 4300 3250
Wire Bus Line
	6100 1650 6100 4250
Wire Bus Line
	4650 4250 4650 5800
Wire Bus Line
	4300 700  4300 2450
Wire Bus Line
	7950 700  7950 3250
Wire Bus Line
	950  700  950  6700
Connection ~ 4300 3250
Wire Wire Line
	4300 3250 4700 3250
$EndSCHEMATC
