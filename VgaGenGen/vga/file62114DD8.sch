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
L 74xx:74LS14 U?
U 1 1 621248B2
P 6650 5550
F 0 "U?" H 6650 5867 50  0000 C CNN
F 1 "74LS14" H 6650 5776 50  0000 C CNN
F 2 "" H 6650 5550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 6650 5550 50  0001 C CNN
	1    6650 5550
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS14 U?
U 2 1 621248B8
P 7250 5550
F 0 "U?" H 7250 5867 50  0000 C CNN
F 1 "74LS14" H 7250 5776 50  0000 C CNN
F 2 "" H 7250 5550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 7250 5550 50  0001 C CNN
	2    7250 5550
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS14 U?
U 3 1 621248BE
P 8200 2500
F 0 "U?" H 8200 2817 50  0000 C CNN
F 1 "74LS14" H 8200 2726 50  0000 C CNN
F 2 "" H 8200 2500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 8200 2500 50  0001 C CNN
	3    8200 2500
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 1 1 621248C4
P 6950 4600
F 0 "U?" H 6950 4925 50  0000 C CNN
F 1 "74LS08" H 6950 4834 50  0000 C CNN
F 2 "" H 6950 4600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 6950 4600 50  0001 C CNN
	1    6950 4600
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 2 1 621248CA
P 7700 4600
F 0 "U?" H 7700 4925 50  0000 C CNN
F 1 "74LS08" H 7700 4834 50  0000 C CNN
F 2 "" H 7700 4600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 7700 4600 50  0001 C CNN
	2    7700 4600
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 3 1 621248D0
P 7300 3950
F 0 "U?" H 7300 4275 50  0000 C CNN
F 1 "74LS08" H 7300 4184 50  0000 C CNN
F 2 "" H 7300 3950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 7300 3950 50  0001 C CNN
	3    7300 3950
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS08 U?
U 4 1 621248D6
P 7400 3200
F 0 "U?" H 7400 3525 50  0000 C CNN
F 1 "74LS08" H 7400 3434 50  0000 C CNN
F 2 "" H 7400 3200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 7400 3200 50  0001 C CNN
	4    7400 3200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7200 4250 6950 4250
Wire Wire Line
	6950 4250 6950 4300
Wire Wire Line
	7400 4250 7700 4250
Wire Wire Line
	7700 4250 7700 4300
Wire Wire Line
	6850 4900 6850 5050
Wire Wire Line
	6850 5050 6650 5050
Wire Wire Line
	6650 5050 6650 5250
Wire Wire Line
	7250 5250 7250 5050
Wire Wire Line
	7250 5050 7050 5050
Wire Wire Line
	7050 5050 7050 4900
Wire Wire Line
	7400 2900 8200 2900
Wire Wire Line
	8200 2900 8200 2800
Wire Wire Line
	7300 3650 7300 3500
Text GLabel 8200 2200 1    50   Input ~ 0
VRAMSEL
Text GLabel 7400 2250 1    50   Input ~ 0
VRAMSEL'
Connection ~ 7400 2900
Text GLabel 7250 5850 3    50   Input ~ 0
A14
Text GLabel 6650 5850 3    50   Input ~ 0
A15
Text GLabel 7600 5850 3    50   Input ~ 0
A13
Text GLabel 7800 5850 3    50   Input ~ 0
A12
Text GLabel 8050 5850 3    50   Input ~ 0
A11
Wire Wire Line
	7600 5850 7600 4900
Wire Wire Line
	7800 4900 7800 5850
Wire Wire Line
	8050 5850 8050 3500
Wire Wire Line
	7500 3500 8050 3500
Wire Wire Line
	8200 2300 8200 2200
Wire Wire Line
	7400 2250 7400 2900
$EndSCHEMATC
