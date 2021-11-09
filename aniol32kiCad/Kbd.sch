EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 3
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
L 74xx:74LS32 U?
U 2 1 61AFC13A
P 1700 1350
AR Path="/61AFC13A" Ref="U?"  Part="2" 
AR Path="/61AEA36E/61AFC13A" Ref="U?"  Part="2" 
F 0 "U?" H 1700 1675 50  0000 C CNN
F 1 "74LS32" H 1700 1584 50  0000 C CNN
F 2 "" H 1700 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1700 1350 50  0001 C CNN
	2    1700 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U?
U 4 1 61AFC140
P 2300 1650
AR Path="/61AFC140" Ref="U?"  Part="4" 
AR Path="/61AEA36E/61AFC140" Ref="U?"  Part="4" 
F 0 "U?" H 2300 1975 50  0000 C CNN
F 1 "74LS32" H 2300 1884 50  0000 C CNN
F 2 "" H 2300 1650 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2300 1650 50  0001 C CNN
	4    2300 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 1550 2000 1350
Wire Wire Line
	2000 1350 2000 1200
Connection ~ 2000 1350
Text GLabel 1200 1250 0    50   Input ~ 0
IORQ
Wire Wire Line
	1400 1250 1200 1250
Text GLabel 1150 1450 0    50   Input ~ 0
A6
Wire Wire Line
	1400 1450 1150 1450
Text GLabel 1150 1000 0    50   Input ~ 0
RD
Wire Wire Line
	1150 1000 2000 1000
Text GLabel 1150 1750 0    50   Input ~ 0
WR
Wire Wire Line
	1150 1750 2000 1750
Text GLabel 2600 1100 2    50   Input ~ 0
KBDRD
$Comp
L 74xx:74LS32 U?
U 3 1 61AFC152
P 2300 1100
AR Path="/61AFC152" Ref="U?"  Part="3" 
AR Path="/61AEA36E/61AFC152" Ref="U?"  Part="3" 
F 0 "U?" H 2300 1425 50  0000 C CNN
F 1 "74LS32" H 2300 1334 50  0000 C CNN
F 2 "" H 2300 1100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2300 1100 50  0001 C CNN
	3    2300 1100
	1    0    0    -1  
$EndComp
Text GLabel 2600 1650 2    50   Input ~ 0
BZRWR
Text GLabel 4150 5350 3    50   Input ~ 0
C0
$Comp
L Connector:Conn_01x16_Male J?
U 1 1 61B15800
P 3450 5150
AR Path="/61B15800" Ref="J?"  Part="1" 
AR Path="/61AEA36E/61B15800" Ref="J?"  Part="1" 
F 0 "J?" V 3285 5078 50  0000 C CNN
F 1 "Conn_01x16_Male" V 3376 5078 50  0000 C CNN
F 2 "" H 3450 5150 50  0001 C CNN
F 3 "~" H 3450 5150 50  0001 C CNN
	1    3450 5150
	0    1    1    0   
$EndComp
Text GLabel 6650 6150 2    50   Input ~ 0
R7
Text GLabel 6650 6050 2    50   Input ~ 0
R6
Text GLabel 6650 5950 2    50   Input ~ 0
R5
Text GLabel 6650 5850 2    50   Input ~ 0
R4
Text GLabel 6650 5750 2    50   Input ~ 0
R3
Text GLabel 6650 5650 2    50   Input ~ 0
R2
Text GLabel 6650 5550 2    50   Input ~ 0
R1
Text GLabel 6650 5450 2    50   Input ~ 0
R0
Text GLabel 5650 3400 0    50   Input ~ 0
C3
Text GLabel 5650 3300 0    50   Input ~ 0
C2
Text GLabel 5650 3200 0    50   Input ~ 0
C1
Text GLabel 5650 3100 0    50   Input ~ 0
C0
NoConn ~ 5650 3800
NoConn ~ 5650 3700
NoConn ~ 5650 3600
NoConn ~ 5650 3500
Wire Wire Line
	5550 5100 6150 5100
Wire Wire Line
	5550 5950 5550 5100
Wire Wire Line
	5550 5950 5650 5950
Wire Wire Line
	6150 5150 6150 5100
Connection ~ 6150 5100
$Comp
L power:+5V #PWR?
U 1 1 61B1581B
P 6150 5100
AR Path="/61B1581B" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1581B" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 6150 4950 50  0001 C CNN
F 1 "+5V" H 6250 5150 50  0000 C CNN
F 2 "" H 6150 5100 50  0001 C CNN
F 3 "" H 6150 5100 50  0001 C CNN
	1    6150 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 6500 5650 6500
Wire Wire Line
	6150 6500 6150 6450
Connection ~ 6150 6500
$Comp
L power:GND #PWR?
U 1 1 61B15824
P 6150 6500
AR Path="/61B15824" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B15824" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 6150 6250 50  0001 C CNN
F 1 "GND" H 6155 6327 50  0000 C CNN
F 2 "" H 6150 6500 50  0001 C CNN
F 3 "" H 6150 6500 50  0001 C CNN
	1    6150 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 4750 5650 4750
Wire Wire Line
	6150 4750 6150 4700
Connection ~ 6150 4750
$Comp
L power:GND #PWR?
U 1 1 61B1582D
P 6150 4750
AR Path="/61B1582D" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1582D" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 6150 4500 50  0001 C CNN
F 1 "GND" H 6155 4577 50  0000 C CNN
F 2 "" H 6150 4750 50  0001 C CNN
F 3 "" H 6150 4750 50  0001 C CNN
	1    6150 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 1450 5650 1450
Wire Wire Line
	4900 4100 4900 1450
Wire Wire Line
	5650 4100 4900 4100
Wire Wire Line
	5000 1350 5650 1350
Wire Wire Line
	5000 4000 5000 1350
Wire Wire Line
	5650 4000 5000 4000
Wire Wire Line
	5100 1250 5650 1250
Wire Wire Line
	5100 5650 5100 1250
Wire Wire Line
	5650 5650 5100 5650
Wire Wire Line
	5200 1150 5650 1150
Wire Wire Line
	5200 5550 5200 1150
Wire Wire Line
	5650 5550 5200 5550
Wire Wire Line
	5300 1050 5650 1050
Wire Wire Line
	5300 5450 5300 1050
Wire Wire Line
	5650 5450 5300 5450
Text GLabel 5650 1650 0    50   Input ~ 0
SHIFT
Text GLabel 5650 1550 0    50   Input ~ 0
ALT
Connection ~ 4900 1450
Wire Wire Line
	4650 1450 4900 1450
Connection ~ 5000 1350
Wire Wire Line
	4650 1350 5000 1350
Connection ~ 5100 1250
Wire Wire Line
	4650 1250 5100 1250
Connection ~ 5200 1150
Wire Wire Line
	4650 1150 5200 1150
Connection ~ 5300 1050
Wire Wire Line
	4650 1050 5300 1050
Wire Wire Line
	5650 6150 5650 6050
Wire Wire Line
	5650 6500 5650 6150
Connection ~ 5650 6150
$Comp
L 74xx:74LS138 U?
U 1 1 61B15851
P 6150 5750
AR Path="/61B15851" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B15851" Ref="U?"  Part="1" 
F 0 "U?" H 6300 6200 50  0000 C CNN
F 1 "74LS138" V 6150 5700 50  0000 C CNN
F 2 "" H 6150 5750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS138" H 6150 5750 50  0001 C CNN
	1    6150 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 4400 5650 4200
Wire Wire Line
	5650 4750 5650 4400
Connection ~ 5650 4400
$Comp
L 74xx:74LS151 U?
U 1 1 61B1585A
P 6150 3700
AR Path="/61B1585A" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1585A" Ref="U?"  Part="1" 
F 0 "U?" H 6300 4450 50  0000 C CNN
F 1 "74LS151" V 6150 3650 50  0000 C CNN
F 2 "" H 6150 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS151" H 6150 3700 50  0001 C CNN
	1    6150 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2600 5650 2050
Text GLabel 5650 2600 3    50   Input ~ 0
KBDRD
$Comp
L power:GND #PWR?
U 1 1 61B15862
P 4250 2150
AR Path="/61B15862" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B15862" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4250 1900 50  0001 C CNN
F 1 "GND" H 4255 1977 50  0000 C CNN
F 2 "" H 4250 2150 50  0001 C CNN
F 3 "" H 4250 2150 50  0001 C CNN
	1    4250 2150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61B15868
P 4250 850
AR Path="/61B15868" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B15868" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4250 700 50  0001 C CNN
F 1 "+5V" H 4265 1023 50  0000 C CNN
F 2 "" H 4250 850 50  0001 C CNN
F 3 "" H 4250 850 50  0001 C CNN
	1    4250 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 2400 6150 2450
Wire Wire Line
	5500 1750 5500 2400
Wire Wire Line
	6150 2400 5500 2400
Connection ~ 6150 2400
Wire Wire Line
	6150 2350 6150 2400
Wire Wire Line
	5650 1750 5500 1750
NoConn ~ 4650 1750
NoConn ~ 4650 1650
NoConn ~ 4650 1550
$Comp
L 74xx:74LS590 U?
U 1 1 61B1587F
P 4250 1550
AR Path="/61B1587F" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1587F" Ref="U?"  Part="1" 
F 0 "U?" H 4400 2200 50  0000 C CNN
F 1 "74LS590" V 4250 1600 50  0000 C CNN
F 2 "" H 4250 1600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls590" H 4250 1600 50  0001 C CNN
	1    4250 1550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 61B15885
P 6150 2450
AR Path="/61B15885" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B15885" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 6150 2200 50  0001 C CNN
F 1 "GND" H 6155 2277 50  0000 C CNN
F 2 "" H 6150 2450 50  0001 C CNN
F 3 "" H 6150 2450 50  0001 C CNN
	1    6150 2450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61B1588B
P 6150 750
AR Path="/61B1588B" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1588B" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 6150 600 50  0001 C CNN
F 1 "+5V" H 6165 923 50  0000 C CNN
F 2 "" H 6150 750 50  0001 C CNN
F 3 "" H 6150 750 50  0001 C CNN
	1    6150 750 
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS573 U?
U 1 1 61B15891
P 6150 1550
AR Path="/61B15891" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B15891" Ref="U?"  Part="1" 
F 0 "U?" H 6300 2200 50  0000 C CNN
F 1 "74LS573" V 6150 1600 50  0000 C CNN
F 2 "" H 6150 1550 50  0001 C CNN
F 3 "74xx/74hc573.pdf" H 6150 1550 50  0001 C CNN
	1    6150 1550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS74 U?
U 1 1 61B1ED83
P 3300 3700
AR Path="/61B1ED83" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1ED83" Ref="U?"  Part="1" 
F 0 "U?" H 3400 3950 50  0000 C CNN
F 1 "74LS74" H 3450 3450 50  0000 C CNN
F 2 "" H 3300 3700 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 3300 3700 50  0001 C CNN
	1    3300 3700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U?
U 1 1 61B1ED89
P 3000 4500
AR Path="/61B1ED89" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1ED89" Ref="U?"  Part="1" 
F 0 "U?" H 3000 4825 50  0000 C CNN
F 1 "74LS08" H 3000 4734 50  0000 C CNN
F 2 "" H 3000 4500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 3000 4500 50  0001 C CNN
	1    3000 4500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U?
U 1 1 61B1ED8F
P 2400 4400
AR Path="/61B1ED8F" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1ED8F" Ref="U?"  Part="1" 
F 0 "U?" H 2400 4725 50  0000 C CNN
F 1 "74LS32" H 2400 4634 50  0000 C CNN
F 2 "" H 2400 4400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2400 4400 50  0001 C CNN
	1    2400 4400
	1    0    0    -1  
$EndComp
Text GLabel 1900 4300 0    50   Input ~ 0
IORQ
Wire Wire Line
	1900 4300 2100 4300
Text GLabel 1850 4500 0    50   Input ~ 0
M1
Wire Wire Line
	1850 4500 2100 4500
Wire Wire Line
	1850 4700 2700 4700
Wire Wire Line
	2700 4700 2700 4600
Wire Wire Line
	3300 4500 3300 4000
$Comp
L power:+5V #PWR?
U 1 1 61B1ED9C
P 3300 3400
AR Path="/61B1ED9C" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1ED9C" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3300 3250 50  0001 C CNN
F 1 "+5V" H 3315 3573 50  0000 C CNN
F 2 "" H 3300 3400 50  0001 C CNN
F 3 "" H 3300 3400 50  0001 C CNN
	1    3300 3400
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61B1EDA2
P 3000 3400
AR Path="/61B1EDA2" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1EDA2" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3000 3250 50  0001 C CNN
F 1 "+5V" H 3015 3573 50  0000 C CNN
F 2 "" H 3000 3400 50  0001 C CNN
F 3 "" H 3000 3400 50  0001 C CNN
	1    3000 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3400 3000 3600
Text GLabel 2800 3700 0    50   Input ~ 0
KEYPRESS
Wire Wire Line
	2800 3700 3000 3700
Text GLabel 1850 4700 0    50   Input ~ 0
RST
$Comp
L 74xx:74LS74 U?
U 2 1 61B1EDAC
P 2200 2400
AR Path="/61B1EDAC" Ref="U?"  Part="2" 
AR Path="/61AEA36E/61B1EDAC" Ref="U?"  Part="2" 
F 0 "U?" H 2300 2650 50  0000 C CNN
F 1 "74LS74" H 2350 2150 50  0000 C CNN
F 2 "" H 2200 2400 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 2200 2400 50  0001 C CNN
	2    2200 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7950 2450 7800 2450
$Comp
L power:GND #PWR?
U 1 1 61B2A1CC
P 7950 2450
AR Path="/61B2A1CC" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B2A1CC" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7950 2200 50  0001 C CNN
F 1 "GND" H 7955 2277 50  0000 C CNN
F 2 "" H 7950 2450 50  0001 C CNN
F 3 "" H 7950 2450 50  0001 C CNN
	1    7950 2450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Network08 RN?
U 1 1 61B2A1DA
P 7400 2250
F 0 "RN?" V 7925 2250 50  0000 C CNN
F 1 "R_Network08" V 7834 2250 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP9" V 7875 2250 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 7400 2250 50  0001 C CNN
	1    7400 2250
	-1   0    0    1   
$EndComp
Text GLabel 8200 1050 2    50   Input ~ 0
D0
Wire Wire Line
	6650 1050 7100 1050
Text GLabel 8200 1150 2    50   Input ~ 0
D1
Text GLabel 8200 1250 2    50   Input ~ 0
D2
Text GLabel 8200 1350 2    50   Input ~ 0
D3
Text GLabel 8200 1450 2    50   Input ~ 0
D4
Text GLabel 8200 1550 2    50   Input ~ 0
D5
Text GLabel 8200 1650 2    50   Input ~ 0
D6
Text GLabel 8200 1750 2    50   Input ~ 0
D7
Wire Wire Line
	8200 1750 7800 1750
Wire Wire Line
	8200 1650 7700 1650
Wire Wire Line
	8200 1550 7600 1550
Wire Wire Line
	8200 1450 7500 1450
Wire Wire Line
	8200 1350 7400 1350
Wire Wire Line
	8200 1250 7300 1250
Wire Wire Line
	8200 1150 7200 1150
Wire Wire Line
	7100 2050 7100 1050
Connection ~ 7100 1050
Wire Wire Line
	7100 1050 8200 1050
Wire Wire Line
	7200 2050 7200 1150
Connection ~ 7200 1150
Wire Wire Line
	7200 1150 6650 1150
Wire Wire Line
	7300 2050 7300 1250
Connection ~ 7300 1250
Wire Wire Line
	7300 1250 6650 1250
Wire Wire Line
	7400 2050 7400 1350
Connection ~ 7400 1350
Wire Wire Line
	7400 1350 6650 1350
Wire Wire Line
	7500 2050 7500 1450
Connection ~ 7500 1450
Wire Wire Line
	7500 1450 6650 1450
Wire Wire Line
	7600 2050 7600 1550
Connection ~ 7600 1550
Wire Wire Line
	7600 1550 6650 1550
Wire Wire Line
	7700 2050 7700 1650
Connection ~ 7700 1650
Wire Wire Line
	7700 1650 6650 1650
Wire Wire Line
	7800 2050 7800 1750
Connection ~ 7800 1750
Wire Wire Line
	7800 1750 6650 1750
Text GLabel 1900 2300 0    50   Input ~ 0
D7
Text GLabel 1900 2400 0    50   Input ~ 0
BZRWR
$Comp
L Connector:Conn_01x02_Male J?
U 1 1 61B45D9D
P 2950 2400
F 0 "J?" H 2922 2282 50  0000 R CNN
F 1 "Conn_01x02_Male" H 2922 2373 50  0000 R CNN
F 2 "" H 2950 2400 50  0001 C CNN
F 3 "~" H 2950 2400 50  0001 C CNN
	1    2950 2400
	-1   0    0    1   
$EndComp
Wire Wire Line
	2750 2300 2500 2300
$Comp
L power:GND #PWR?
U 1 1 61B4867B
P 2750 2400
F 0 "#PWR?" H 2750 2150 50  0001 C CNN
F 1 "GND" H 2755 2227 50  0000 C CNN
F 2 "" H 2750 2400 50  0001 C CNN
F 3 "" H 2750 2400 50  0001 C CNN
	1    2750 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 61B48E69
P 2200 2700
F 0 "#PWR?" H 2200 2450 50  0001 C CNN
F 1 "GND" H 2205 2527 50  0000 C CNN
F 2 "" H 2200 2700 50  0001 C CNN
F 3 "" H 2200 2700 50  0001 C CNN
	1    2200 2700
	1    0    0    -1  
$EndComp
$EndSCHEMATC
