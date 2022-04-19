EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 5
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
U 1 1 624B3802
P 1350 1200
F 0 "U?" H 1350 1517 50  0000 C CNN
F 1 "74LS14" H 1350 1426 50  0000 C CNN
F 2 "" H 1350 1200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 1350 1200 50  0001 C CNN
	1    1350 1200
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 624B4478
P 1350 1650
F 0 "R?" V 1154 1650 50  0000 C CNN
F 1 "R_Small" V 1245 1650 50  0000 C CNN
F 2 "" H 1350 1650 50  0001 C CNN
F 3 "~" H 1350 1650 50  0001 C CNN
	1    1350 1650
	0    1    1    0   
$EndComp
Wire Wire Line
	1450 1650 1650 1650
Wire Wire Line
	1650 1650 1650 1200
Wire Wire Line
	1250 1650 1050 1650
Wire Wire Line
	1050 1650 1050 1200
$Comp
L Device:C_Small C?
U 1 1 624B4CD6
P 1050 1750
F 0 "C?" H 1142 1796 50  0000 L CNN
F 1 "C_Small" H 1142 1705 50  0000 L CNN
F 2 "" H 1050 1750 50  0001 C CNN
F 3 "~" H 1050 1750 50  0001 C CNN
	1    1050 1750
	1    0    0    -1  
$EndComp
Connection ~ 1050 1650
$Comp
L power:GND #PWR?
U 1 1 624B4F69
P 1050 1850
F 0 "#PWR?" H 1050 1600 50  0001 C CNN
F 1 "GND" H 1055 1677 50  0000 C CNN
F 2 "" H 1050 1850 50  0001 C CNN
F 3 "" H 1050 1850 50  0001 C CNN
	1    1050 1850
	1    0    0    -1  
$EndComp
Text GLabel 2900 1200 2    50   Input ~ 0
NMI
Wire Wire Line
	1950 1200 1650 1200
Connection ~ 1650 1200
$Comp
L 74xx:74LS245 U?
U 1 1 624B544C
P 5100 2150
F 0 "U?" H 5250 2900 50  0000 C CNN
F 1 "74LS245" H 5100 1850 50  0000 C CNN
F 2 "" H 5100 2150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 5100 2150 50  0001 C CNN
	1    5100 2150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 624B5DD9
P 5100 3150
F 0 "#PWR?" H 5100 2900 50  0001 C CNN
F 1 "GND" H 5105 2977 50  0000 C CNN
F 2 "" H 5100 3150 50  0001 C CNN
F 3 "" H 5100 3150 50  0001 C CNN
	1    5100 3150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 624B6278
P 5100 1200
F 0 "#PWR?" H 5100 1050 50  0001 C CNN
F 1 "+5V" H 5115 1373 50  0000 C CNN
F 2 "" H 5100 1200 50  0001 C CNN
F 3 "" H 5100 1200 50  0001 C CNN
	1    5100 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 1200 5100 1250
Connection ~ 5100 1250
Wire Wire Line
	5100 1250 5100 1350
$Comp
L 74xx:74LS32 U?
U 2 1 624B8F86
P 2250 3850
F 0 "U?" H 2250 4175 50  0000 C CNN
F 1 "74LS32" H 2250 4084 50  0000 C CNN
F 2 "" H 2250 3850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2250 3850 50  0001 C CNN
	2    2250 3850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U?
U 3 1 624B995C
P 2200 3300
F 0 "U?" H 2200 3625 50  0000 C CNN
F 1 "74LS32" H 2200 3534 50  0000 C CNN
F 2 "" H 2200 3300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2200 3300 50  0001 C CNN
	3    2200 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 3750 1800 3750
Text GLabel 1650 3200 0    50   Input ~ 0
A4
Text GLabel 1700 3400 0    50   Input ~ 0
IORQ
Text GLabel 1600 3950 0    50   Input ~ 0
A6
$Comp
L 74xx:74LS74 U?
U 1 1 624BCBB3
P 3400 3850
F 0 "U?" H 3400 3850 50  0000 C CNN
F 1 "74LS74" H 3550 4100 50  0000 C CNN
F 2 "" H 3400 3850 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 3400 3850 50  0001 C CNN
	1    3400 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 3850 2550 3850
$Comp
L power:+5V #PWR?
U 1 1 624BEEBB
P 3400 3550
F 0 "#PWR?" H 3400 3400 50  0001 C CNN
F 1 "+5V" H 3415 3723 50  0000 C CNN
F 2 "" H 3400 3550 50  0001 C CNN
F 3 "" H 3400 3550 50  0001 C CNN
	1    3400 3550
	1    0    0    -1  
$EndComp
Text GLabel 3400 4150 3    50   Input ~ 0
RST
$Comp
L Device:Buzzer BZ?
U 1 1 624C04CF
P 4250 3850
F 0 "BZ?" H 4402 3879 50  0000 L CNN
F 1 "Buzzer" H 4402 3788 50  0000 L CNN
F 2 "" V 4225 3950 50  0001 C CNN
F 3 "~" V 4225 3950 50  0001 C CNN
	1    4250 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4150 3750 3700 3750
$Comp
L power:GND #PWR?
U 1 1 624C111C
P 4150 3950
F 0 "#PWR?" H 4150 3700 50  0001 C CNN
F 1 "GND" H 4155 3777 50  0000 C CNN
F 2 "" H 4150 3950 50  0001 C CNN
F 3 "" H 4150 3950 50  0001 C CNN
	1    4150 3950
	1    0    0    -1  
$EndComp
Text GLabel 3550 1650 0    50   Input ~ 0
C0
Text GLabel 3550 1750 0    50   Input ~ 0
C1
Text GLabel 3550 1850 0    50   Input ~ 0
C2
Text GLabel 3550 1950 0    50   Input ~ 0
C3
Text GLabel 3550 2050 0    50   Input ~ 0
C4
Text GLabel 3550 2150 0    50   Input ~ 0
C5
Text GLabel 3550 2250 0    50   Input ~ 0
C6
Text GLabel 3550 2350 0    50   Input ~ 0
C7
Text GLabel 5600 1650 2    50   Input ~ 0
D0
Text GLabel 5600 1750 2    50   Input ~ 0
D1
Text GLabel 5600 1850 2    50   Input ~ 0
D2
Text GLabel 5600 1950 2    50   Input ~ 0
D3
Text GLabel 5600 2050 2    50   Input ~ 0
D4
Text GLabel 5600 2150 2    50   Input ~ 0
D5
Text GLabel 5600 2250 2    50   Input ~ 0
D6
Text GLabel 5600 2350 2    50   Input ~ 0
D7
Text GLabel 3000 3750 0    50   Input ~ 0
D7
$Comp
L 74xx:74LS32 U?
U 4 1 624C56CC
P 1650 4550
F 0 "U?" H 1650 4875 50  0000 C CNN
F 1 "74LS32" H 1650 4784 50  0000 C CNN
F 2 "" H 1650 4550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1650 4550 50  0001 C CNN
	4    1650 4550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U?
U 2 1 624C73AD
P 2250 4550
F 0 "U?" H 2250 4867 50  0000 C CNN
F 1 "74LS14" H 2250 4776 50  0000 C CNN
F 2 "" H 2250 4550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 2250 4550 50  0001 C CNN
	2    2250 4550
	1    0    0    -1  
$EndComp
Text GLabel 1350 4450 0    50   Input ~ 0
A5
Text GLabel 1350 4650 0    50   Input ~ 0
IORQ
Text GLabel 2550 4550 2    50   Input ~ 0
LCDE
NoConn ~ 3700 3950
$Comp
L 74xx:74LS14 U?
U 3 1 624C8F26
P 2200 5650
F 0 "U?" H 2200 5967 50  0000 C CNN
F 1 "74LS14" H 2200 5876 50  0000 C CNN
F 2 "" H 2200 5650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 2200 5650 50  0001 C CNN
	3    2200 5650
	1    0    0    -1  
$EndComp
$Comp
L Oscillator:CXO_DIP14 X?
U 1 1 624CA05C
P 1600 5650
F 0 "X?" H 1944 5696 50  0000 L CNN
F 1 "CXO_DIP14" H 1944 5605 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-14" H 2050 5300 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 1500 5650 50  0001 C CNN
	1    1600 5650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 624CCB3C
P 1600 5350
F 0 "#PWR?" H 1600 5200 50  0001 C CNN
F 1 "+5V" H 1615 5523 50  0000 C CNN
F 2 "" H 1600 5350 50  0001 C CNN
F 3 "" H 1600 5350 50  0001 C CNN
	1    1600 5350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 624CCC72
P 1600 5950
F 0 "#PWR?" H 1600 5700 50  0001 C CNN
F 1 "GND" H 1605 5777 50  0000 C CNN
F 2 "" H 1600 5950 50  0001 C CNN
F 3 "" H 1600 5950 50  0001 C CNN
	1    1600 5950
	1    0    0    -1  
$EndComp
Text GLabel 2500 5650 2    50   Input ~ 0
CLK
$Comp
L Device:R_Network08 RN?
U 1 1 624CFDEB
P 4050 2700
F 0 "RN?" H 4400 2900 50  0000 R CNN
F 1 "R_Network08" H 4250 2900 50  0000 R CNN
F 2 "Resistor_THT:R_Array_SIP9" V 4525 2700 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 4050 2700 50  0001 C CNN
	1    4050 2700
	-1   0    0    1   
$EndComp
Wire Wire Line
	4600 2350 4450 2350
Wire Wire Line
	3550 2250 4350 2250
Wire Wire Line
	3550 2050 4150 2050
Wire Wire Line
	4600 1950 4050 1950
Wire Wire Line
	3550 1850 3950 1850
Wire Wire Line
	4600 1750 3850 1750
Wire Wire Line
	3550 1650 3750 1650
Wire Wire Line
	3750 2500 3750 1650
Connection ~ 3750 1650
Wire Wire Line
	3750 1650 4600 1650
Wire Wire Line
	3850 2500 3850 1750
Connection ~ 3850 1750
Wire Wire Line
	3850 1750 3550 1750
Wire Wire Line
	3950 2500 3950 1850
Connection ~ 3950 1850
Wire Wire Line
	3950 1850 4600 1850
Wire Wire Line
	4050 2500 4050 1950
Connection ~ 4050 1950
Wire Wire Line
	4050 1950 3550 1950
Wire Wire Line
	4150 2500 4150 2050
Connection ~ 4150 2050
Wire Wire Line
	4150 2050 4600 2050
Wire Wire Line
	4250 2500 4250 2150
Connection ~ 4250 2150
Wire Wire Line
	4250 2150 3550 2150
Wire Wire Line
	4600 2150 4250 2150
Wire Wire Line
	4350 2500 4350 2250
Connection ~ 4350 2250
Wire Wire Line
	4450 2900 4450 2950
Wire Wire Line
	5100 3150 5100 2950
Connection ~ 5100 2950
$Comp
L Device:C_Small C?
U 1 1 624EFFA9
P 2050 1200
F 0 "C?" V 1821 1200 50  0000 C CNN
F 1 "C_Small" V 1912 1200 50  0000 C CNN
F 2 "" H 2050 1200 50  0001 C CNN
F 3 "~" H 2050 1200 50  0001 C CNN
	1    2050 1200
	0    1    1    0   
$EndComp
$Comp
L 74xx:74LS14 U?
U 4 1 624F06FC
P 2600 1200
F 0 "U?" H 2600 1517 50  0000 C CNN
F 1 "74LS14" H 2600 1426 50  0000 C CNN
F 2 "" H 2600 1200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 2600 1200 50  0001 C CNN
	4    2600 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2300 1200 2200 1200
$Comp
L Device:R_Small R?
U 1 1 624F33B0
P 2200 1600
F 0 "R?" H 2259 1646 50  0000 L CNN
F 1 "R_Small" H 2259 1555 50  0000 L CNN
F 2 "" H 2200 1600 50  0001 C CNN
F 3 "~" H 2200 1600 50  0001 C CNN
	1    2200 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 1500 2200 1200
Connection ~ 2200 1200
Wire Wire Line
	2200 1200 2150 1200
$Comp
L power:GND #PWR?
U 1 1 624F45D0
P 2200 1850
F 0 "#PWR?" H 2200 1600 50  0001 C CNN
F 1 "GND" H 2205 1677 50  0000 C CNN
F 2 "" H 2200 1850 50  0001 C CNN
F 3 "" H 2200 1850 50  0001 C CNN
	1    2200 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 1850 2200 1700
$Comp
L Connector:Conn_01x12_Male J?
U 1 1 624F6497
P 4650 5000
F 0 "J?" V 4485 4928 50  0000 C CNN
F 1 "Conn_01x12_Male" V 4576 4928 50  0000 C CNN
F 2 "" H 4650 5000 50  0001 C CNN
F 3 "~" H 4650 5000 50  0001 C CNN
	1    4650 5000
	0    -1   1    0   
$EndComp
Text GLabel 4150 5200 3    50   Input ~ 0
C0
Text GLabel 4250 5200 3    50   Input ~ 0
C1
Text GLabel 4350 5200 3    50   Input ~ 0
C2
Text GLabel 4450 5200 3    50   Input ~ 0
C3
Text GLabel 4550 5200 3    50   Input ~ 0
C4
Text GLabel 4650 5200 3    50   Input ~ 0
C5
Text GLabel 4750 5200 3    50   Input ~ 0
C6
Text GLabel 4850 5200 3    50   Input ~ 0
C7
$Comp
L Device:R_Small R?
U 1 1 624FC3C2
P 4950 5300
F 0 "R?" H 4900 5800 50  0000 L CNN
F 1 "4k7" V 4950 5250 50  0000 L CNN
F 2 "" H 4950 5300 50  0001 C CNN
F 3 "~" H 4950 5300 50  0001 C CNN
	1    4950 5300
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 624FEFA0
P 5150 5300
F 0 "R?" H 5100 5800 50  0000 L CNN
F 1 "4k7" V 5150 5250 50  0000 L CNN
F 2 "" H 5150 5300 50  0001 C CNN
F 3 "~" H 5150 5300 50  0001 C CNN
	1    5150 5300
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 624FF512
P 5250 5300
F 0 "R?" H 5200 5800 50  0000 L CNN
F 1 "4k7" V 5250 5250 50  0000 L CNN
F 2 "" H 5250 5300 50  0001 C CNN
F 3 "~" H 5250 5300 50  0001 C CNN
	1    5250 5300
	1    0    0    -1  
$EndComp
Text GLabel 4950 5400 3    50   Input ~ 0
A0
$Comp
L Device:R_Small R?
U 1 1 624FD724
P 5050 5300
F 0 "R?" H 5000 5800 50  0000 L CNN
F 1 "4k7" V 5050 5250 50  0000 L CNN
F 2 "" H 5050 5300 50  0001 C CNN
F 3 "~" H 5050 5300 50  0001 C CNN
	1    5050 5300
	1    0    0    -1  
$EndComp
Text GLabel 5050 5400 3    50   Input ~ 0
A1
Text GLabel 5150 5400 3    50   Input ~ 0
A2
Text GLabel 5250 5400 3    50   Input ~ 0
A3
Wire Wire Line
	5100 1250 4550 1250
Wire Wire Line
	4600 2550 4550 2550
Wire Wire Line
	4550 2550 4550 1250
Wire Wire Line
	4350 2250 4600 2250
Wire Wire Line
	4450 2500 4450 2350
Connection ~ 4450 2350
Wire Wire Line
	4450 2350 3550 2350
Wire Wire Line
	5100 2950 4450 2950
Wire Wire Line
	3100 3750 3000 3750
Wire Wire Line
	4600 2650 4600 3300
Wire Wire Line
	2500 3300 4600 3300
Wire Wire Line
	1900 3400 1800 3400
Wire Wire Line
	1800 3750 1800 3400
Connection ~ 1800 3400
Wire Wire Line
	1800 3400 1700 3400
Wire Wire Line
	1950 3950 1600 3950
Wire Wire Line
	1650 3200 1900 3200
$EndSCHEMATC
