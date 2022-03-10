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
L 74xx:74LS14 U?
U 1 1 6197C3A8
P 2700 3050
F 0 "U?" H 2700 3367 50  0000 C CNN
F 1 "74LS14" H 2700 3276 50  0000 C CNN
F 2 "" H 2700 3050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 2700 3050 50  0001 C CNN
	1    2700 3050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U?
U 2 1 6197D2AA
P 4050 3050
F 0 "U?" H 4050 3367 50  0000 C CNN
F 1 "74LS14" H 4050 3276 50  0000 C CNN
F 2 "" H 4050 3050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 4050 3050 50  0001 C CNN
	2    4050 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 6197E441
P 2400 3450
F 0 "C?" H 2492 3496 50  0000 L CNN
F 1 "C_Small" H 2492 3405 50  0000 L CNN
F 2 "" H 2400 3450 50  0001 C CNN
F 3 "~" H 2400 3450 50  0001 C CNN
	1    2400 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 3350 2400 3300
$Comp
L Device:C_Small C?
U 1 1 6197EAC4
P 3400 3050
F 0 "C?" V 3171 3050 50  0000 C CNN
F 1 "C_Small" V 3262 3050 50  0000 C CNN
F 2 "" H 3400 3050 50  0001 C CNN
F 3 "~" H 3400 3050 50  0001 C CNN
	1    3400 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	3300 3050 3150 3050
Wire Wire Line
	3500 3050 3650 3050
Text GLabel 4350 3050 2    50   Input ~ 0
NMI
$Comp
L Device:R_Small R?
U 1 1 6197F751
P 3650 3300
F 0 "R?" H 3709 3346 50  0000 L CNN
F 1 "R_Small" H 3709 3255 50  0000 L CNN
F 2 "" H 3650 3300 50  0001 C CNN
F 3 "~" H 3650 3300 50  0001 C CNN
	1    3650 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 3200 3650 3050
Connection ~ 3650 3050
Wire Wire Line
	3650 3050 3750 3050
$Comp
L Device:R_Small R?
U 1 1 619803F0
P 2950 3300
F 0 "R?" V 2754 3300 50  0000 C CNN
F 1 "R_Small" V 2845 3300 50  0000 C CNN
F 2 "" H 2950 3300 50  0001 C CNN
F 3 "~" H 2950 3300 50  0001 C CNN
	1    2950 3300
	0    1    1    0   
$EndComp
Wire Wire Line
	3050 3300 3150 3300
Wire Wire Line
	3150 3300 3150 3050
Connection ~ 3150 3050
Wire Wire Line
	3150 3050 3000 3050
Wire Wire Line
	2850 3300 2400 3300
Connection ~ 2400 3300
Wire Wire Line
	2400 3300 2400 3050
$Comp
L power:GND #PWR?
U 1 1 61980DA0
P 2400 3750
F 0 "#PWR?" H 2400 3500 50  0001 C CNN
F 1 "GND" H 2405 3577 50  0000 C CNN
F 2 "" H 2400 3750 50  0001 C CNN
F 3 "" H 2400 3750 50  0001 C CNN
	1    2400 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 3750 2400 3550
$Comp
L power:GND #PWR?
U 1 1 619813D1
P 3650 3750
F 0 "#PWR?" H 3650 3500 50  0001 C CNN
F 1 "GND" H 3655 3577 50  0000 C CNN
F 2 "" H 3650 3750 50  0001 C CNN
F 3 "" H 3650 3750 50  0001 C CNN
	1    3650 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 3400 3650 3750
$EndSCHEMATC
