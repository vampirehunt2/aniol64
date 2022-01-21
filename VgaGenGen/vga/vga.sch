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
P 2950 1400
F 0 "U?" H 2950 2381 50  0000 C CNN
F 1 "4040" H 2950 2290 50  0000 C CNN
F 2 "" H 2950 1400 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 2950 1400 50  0001 C CNN
	1    2950 1400
	-1   0    0    1   
$EndComp
$Comp
L 4xxx:4040 U?
U 1 1 61BA51A9
P 2950 3350
F 0 "U?" H 2950 4331 50  0000 C CNN
F 1 "4040" H 2950 4240 50  0000 C CNN
F 2 "" H 2950 3350 50  0001 C CNN
F 3 "http://www.intersil.com/content/dam/Intersil/documents/cd40/cd4020bms-24bms-40bms.pdf" H 2950 3350 50  0001 C CNN
	1    2950 3350
	-1   0    0    1   
$EndComp
$Comp
L Memory_EPROM:27C512 U?
U 1 1 61EB0A99
P 2850 5750
F 0 "U?" H 2850 7031 50  0000 C CNN
F 1 "27C512" H 2850 6940 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 2850 5750 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0015.pdf" H 2850 5750 50  0001 C CNN
	1    2850 5750
	1    0    0    -1  
$EndComp
$Comp
L Oscillator:CXO_DIP14 X?
U 1 1 61EB14A1
P 4400 1900
F 0 "X?" H 4056 1854 50  0000 R CNN
F 1 "CXO_DIP14" H 4056 1945 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 4850 1550 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 4300 1900 50  0001 C CNN
	1    4400 1900
	-1   0    0    1   
$EndComp
Wire Wire Line
	4100 1900 3450 1900
Entry Wire Line
	2100 900  2200 1000
Entry Wire Line
	2100 1000 2200 1100
Entry Wire Line
	2100 1100 2200 1200
Entry Wire Line
	2100 1200 2200 1300
Entry Wire Line
	2100 1300 2200 1400
Entry Wire Line
	2100 1400 2200 1500
Wire Wire Line
	2450 1500 2200 1500
Wire Wire Line
	2450 1400 2200 1400
Wire Wire Line
	2450 1300 2200 1300
Wire Wire Line
	2450 1200 2200 1200
Wire Wire Line
	2450 1100 2200 1100
Wire Wire Line
	2450 1000 2200 1000
Text GLabel 3950 4850 2    50   Input ~ 0
vSync
Text GLabel 3950 4950 2    50   Input ~ 0
hSync
Text GLabel 3950 5050 2    50   Input ~ 0
Blanking
Text GLabel 3950 5450 2    50   Input ~ 0
Video
Wire Wire Line
	3950 5450 3250 5450
Wire Wire Line
	3950 5050 3250 5050
Wire Wire Line
	3950 4950 3250 4950
Wire Wire Line
	3950 4850 3250 4850
Wire Wire Line
	3250 5150 3650 5150
Wire Wire Line
	3650 5150 3650 1600
Wire Wire Line
	3650 1600 3450 1600
Wire Wire Line
	3250 5250 3550 5250
Wire Wire Line
	3550 5250 3550 3550
Wire Wire Line
	3550 3550 3450 3550
Wire Wire Line
	3250 5350 3450 5350
Wire Wire Line
	3450 5350 3450 3850
Entry Wire Line
	2100 2850 2200 2950
Entry Wire Line
	2100 2950 2200 3050
Entry Wire Line
	2100 3050 2200 3150
Entry Wire Line
	2100 3150 2200 3250
Entry Wire Line
	2100 3250 2200 3350
Entry Wire Line
	2100 3350 2200 3450
Entry Wire Line
	2100 3450 2200 3550
Entry Wire Line
	2100 3550 2200 3650
Entry Wire Line
	2100 3650 2200 3750
Entry Wire Line
	2100 3750 2200 3850
Wire Wire Line
	2200 2950 2450 2950
Wire Wire Line
	2200 3050 2450 3050
Wire Wire Line
	2200 3150 2450 3150
Wire Wire Line
	2200 3250 2450 3250
Wire Wire Line
	2200 3350 2450 3350
Wire Wire Line
	2200 3450 2450 3450
Wire Wire Line
	2200 3550 2450 3550
Wire Wire Line
	2200 3650 2450 3650
Wire Wire Line
	2200 3750 2450 3750
Wire Wire Line
	2200 3850 2450 3850
Entry Wire Line
	2100 4750 2200 4850
Entry Wire Line
	2100 4850 2200 4950
Entry Wire Line
	2100 4950 2200 5050
Entry Wire Line
	2100 5050 2200 5150
Entry Wire Line
	2100 5150 2200 5250
Entry Wire Line
	2100 5250 2200 5350
Entry Wire Line
	2100 5350 2200 5450
Entry Wire Line
	2100 5450 2200 5550
Entry Wire Line
	2100 5550 2200 5650
Entry Wire Line
	2100 5650 2200 5750
Entry Wire Line
	2100 5750 2200 5850
Entry Wire Line
	2100 5850 2200 5950
Entry Wire Line
	2100 5950 2200 6050
Entry Wire Line
	2100 6050 2200 6150
Entry Wire Line
	2100 6150 2200 6250
Entry Wire Line
	2100 6250 2200 6350
Wire Wire Line
	2450 6350 2200 6350
Wire Wire Line
	2450 6250 2200 6250
Wire Wire Line
	2450 6150 2200 6150
Wire Wire Line
	2450 6050 2200 6050
Wire Wire Line
	2450 5950 2200 5950
Wire Wire Line
	2450 5850 2200 5850
Wire Wire Line
	2450 5750 2200 5750
Wire Wire Line
	2450 5650 2200 5650
Wire Wire Line
	2450 5550 2200 5550
Wire Wire Line
	2450 5450 2200 5450
Wire Wire Line
	2450 5350 2200 5350
Wire Wire Line
	2450 5250 2200 5250
Wire Wire Line
	2450 5150 2200 5150
Wire Wire Line
	2450 5050 2200 5050
Wire Wire Line
	2450 4950 2200 4950
Wire Wire Line
	2450 4850 2200 4850
Wire Wire Line
	2450 6550 2450 6650
Wire Wire Line
	2450 6650 2450 6850
Wire Wire Line
	2450 6850 2850 6850
Connection ~ 2450 6650
$Comp
L power:GND #PWR?
U 1 1 61EDD624
P 2850 6850
F 0 "#PWR?" H 2850 6600 50  0001 C CNN
F 1 "GND" H 2855 6677 50  0000 C CNN
F 2 "" H 2850 6850 50  0001 C CNN
F 3 "" H 2850 6850 50  0001 C CNN
	1    2850 6850
	1    0    0    -1  
$EndComp
Connection ~ 2850 6850
Text Label 2300 1000 0    50   ~ 0
h5
Text Label 2300 1100 0    50   ~ 0
h4
Text Label 2300 1200 0    50   ~ 0
h3
Text Label 2300 1300 0    50   ~ 0
h2
Text Label 2300 1400 0    50   ~ 0
h1
Text Label 2300 1500 0    50   ~ 0
h0
Text Label 2300 2950 0    50   ~ 0
v9
Text Label 2300 3050 0    50   ~ 0
v8
Text Label 2300 3150 0    50   ~ 0
v7
Text Label 2300 3250 0    50   ~ 0
v6
Text Label 2300 3350 0    50   ~ 0
v5
Text Label 2300 3450 0    50   ~ 0
v4
Text Label 2300 3550 0    50   ~ 0
v3
Text Label 2300 3650 0    50   ~ 0
v2
Text Label 2300 3750 0    50   ~ 0
v1
Text Label 2300 3850 0    50   ~ 0
v0
Text Label 2250 4850 0    50   ~ 0
h0
Text Label 2250 4950 0    50   ~ 0
h1
Text Label 2250 5050 0    50   ~ 0
h2
Text Label 2250 5150 0    50   ~ 0
h3
Text Label 2250 5250 0    50   ~ 0
h4
Text Label 2250 5350 0    50   ~ 0
h5
Text Label 2250 5450 0    50   ~ 0
v0
Text Label 2250 5550 0    50   ~ 0
v1
Text Label 2250 5650 0    50   ~ 0
v2
Text Label 2250 5750 0    50   ~ 0
v3
Text Label 2250 5850 0    50   ~ 0
v4
Text Label 2250 5950 0    50   ~ 0
v5
Text Label 2250 6050 0    50   ~ 0
v6
Text Label 2250 6150 0    50   ~ 0
v7
Text Label 2250 6250 0    50   ~ 0
v8
Text Label 2250 6350 0    50   ~ 0
v9
Wire Bus Line
	2100 650  2100 6350
$EndSCHEMATC
