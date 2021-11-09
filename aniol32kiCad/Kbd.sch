EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 5
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
P 1450 2000
AR Path="/61AFC13A" Ref="U?"  Part="2" 
AR Path="/61AEA36E/61AFC13A" Ref="U?"  Part="2" 
F 0 "U?" H 1450 2325 50  0000 C CNN
F 1 "74LS32" H 1450 2234 50  0000 C CNN
F 2 "" H 1450 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1450 2000 50  0001 C CNN
	2    1450 2000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U?
U 4 1 61AFC140
P 2050 2300
AR Path="/61AFC140" Ref="U?"  Part="4" 
AR Path="/61AEA36E/61AFC140" Ref="U?"  Part="4" 
F 0 "U?" H 2050 2625 50  0000 C CNN
F 1 "74LS32" H 2050 2534 50  0000 C CNN
F 2 "" H 2050 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2050 2300 50  0001 C CNN
	4    2050 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 2200 1750 2000
Wire Wire Line
	1750 2000 1750 1850
Connection ~ 1750 2000
Text GLabel 950  1900 0    50   Input ~ 0
IORQ
Wire Wire Line
	1150 1900 950  1900
Text GLabel 900  2100 0    50   Input ~ 0
A6
Wire Wire Line
	1150 2100 900  2100
Text GLabel 900  1650 0    50   Input ~ 0
RD
Wire Wire Line
	900  1650 1750 1650
Text GLabel 900  2400 0    50   Input ~ 0
WR
Wire Wire Line
	900  2400 1750 2400
Text GLabel 2350 1750 2    50   Input ~ 0
KBDRD
$Comp
L 74xx:74LS32 U?
U 3 1 61AFC152
P 2050 1750
AR Path="/61AFC152" Ref="U?"  Part="3" 
AR Path="/61AEA36E/61AFC152" Ref="U?"  Part="3" 
F 0 "U?" H 2050 2075 50  0000 C CNN
F 1 "74LS32" H 2050 1984 50  0000 C CNN
F 2 "" H 2050 1750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2050 1750 50  0001 C CNN
	3    2050 1750
	1    0    0    -1  
$EndComp
Text GLabel 2350 2300 2    50   Input ~ 0
BZRWR
Text GLabel 4150 5350 3    50   Input ~ 0
R0
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
C7
Text GLabel 6650 6050 2    50   Input ~ 0
C6
Text GLabel 6650 5950 2    50   Input ~ 0
C5
Text GLabel 6650 5850 2    50   Input ~ 0
C4
Text GLabel 6650 5750 2    50   Input ~ 0
C3
Text GLabel 6650 5650 2    50   Input ~ 0
C2
Text GLabel 6650 5550 2    50   Input ~ 0
C1
Text GLabel 6650 5450 2    50   Input ~ 0
C0
Text GLabel 6050 3400 0    50   Input ~ 0
R3
Text GLabel 6050 3300 0    50   Input ~ 0
R2
Text GLabel 6050 3200 0    50   Input ~ 0
R1
Text GLabel 6050 3100 0    50   Input ~ 0
R0
NoConn ~ 6800 3800
NoConn ~ 6800 3700
NoConn ~ 6800 3600
NoConn ~ 6800 3500
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
	7300 4750 6800 4750
Wire Wire Line
	7300 4750 7300 4700
Connection ~ 7300 4750
$Comp
L power:GND #PWR?
U 1 1 61B1582D
P 7300 4750
AR Path="/61B1582D" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1582D" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7300 4500 50  0001 C CNN
F 1 "GND" H 7305 4577 50  0000 C CNN
F 2 "" H 7300 4750 50  0001 C CNN
F 3 "" H 7300 4750 50  0001 C CNN
	1    7300 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 1450 5650 1450
Wire Wire Line
	4900 4100 4900 1450
Wire Wire Line
	5000 1350 5650 1350
Wire Wire Line
	5000 4000 5000 1350
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
	6800 4400 6800 4200
Wire Wire Line
	6800 4750 6800 4400
Connection ~ 6800 4400
$Comp
L 74xx:74LS151 U?
U 1 1 61B1585A
P 7300 3700
AR Path="/61B1585A" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1585A" Ref="U?"  Part="1" 
F 0 "U?" H 7450 4450 50  0000 C CNN
F 1 "74LS151" V 7300 3650 50  0000 C CNN
F 2 "" H 7300 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS151" H 7300 3700 50  0001 C CNN
	1    7300 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2600 5650 2050
Text GLabel 5650 2600 3    50   Input ~ 0
KBDRD
$Comp
L power:GND #PWR?
U 1 1 61B15862
P 4250 2300
AR Path="/61B15862" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B15862" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4250 2050 50  0001 C CNN
F 1 "GND" H 4255 2127 50  0000 C CNN
F 2 "" H 4250 2300 50  0001 C CNN
F 3 "" H 4250 2300 50  0001 C CNN
	1    4250 2300
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61B15868
P 4250 750
AR Path="/61B15868" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B15868" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 4250 600 50  0001 C CNN
F 1 "+5V" H 4265 923 50  0000 C CNN
F 2 "" H 4250 750 50  0001 C CNN
F 3 "" H 4250 750 50  0001 C CNN
	1    4250 750 
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
F 1 "GND" H 6250 2450 50  0000 C CNN
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
P 10150 3750
AR Path="/61B1ED83" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1ED83" Ref="U?"  Part="1" 
F 0 "U?" H 10250 4000 50  0000 C CNN
F 1 "74LS74" H 10300 3500 50  0000 C CNN
F 2 "" H 10150 3750 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 10150 3750 50  0001 C CNN
	1    10150 3750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U?
U 1 1 61B1ED89
P 10150 4350
AR Path="/61B1ED89" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1ED89" Ref="U?"  Part="1" 
F 0 "U?" H 10150 4675 50  0000 C CNN
F 1 "74LS08" H 10150 4584 50  0000 C CNN
F 2 "" H 10150 4350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 10150 4350 50  0001 C CNN
	1    10150 4350
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74LS32 U?
U 1 1 61B1ED8F
P 10250 4950
AR Path="/61B1ED8F" Ref="U?"  Part="1" 
AR Path="/61AEA36E/61B1ED8F" Ref="U?"  Part="1" 
F 0 "U?" H 10250 5275 50  0000 C CNN
F 1 "74LS32" H 10250 5184 50  0000 C CNN
F 2 "" H 10250 4950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 10250 4950 50  0001 C CNN
	1    10250 4950
	0    -1   -1   0   
$EndComp
Text GLabel 10150 5450 3    50   Input ~ 0
IORQ
Wire Wire Line
	10150 5450 10150 5250
Text GLabel 10350 5500 3    50   Input ~ 0
M1
Wire Wire Line
	10350 5500 10350 5250
Wire Wire Line
	10050 4750 10050 4650
$Comp
L power:+5V #PWR?
U 1 1 61B1ED9C
P 10150 3450
AR Path="/61B1ED9C" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1ED9C" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 10150 3300 50  0001 C CNN
F 1 "+5V" H 10165 3623 50  0000 C CNN
F 2 "" H 10150 3450 50  0001 C CNN
F 3 "" H 10150 3450 50  0001 C CNN
	1    10150 3450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 61B1EDA2
P 9850 3450
AR Path="/61B1EDA2" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B1EDA2" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 9850 3300 50  0001 C CNN
F 1 "+5V" H 9865 3623 50  0000 C CNN
F 2 "" H 9850 3450 50  0001 C CNN
F 3 "" H 9850 3450 50  0001 C CNN
	1    9850 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9850 3450 9850 3650
Wire Wire Line
	9650 3750 9850 3750
Text GLabel 9850 4750 0    50   Input ~ 0
RST
$Comp
L 74xx:74LS74 U?
U 2 1 61B1EDAC
P 1250 3050
AR Path="/61B1EDAC" Ref="U?"  Part="2" 
AR Path="/61AEA36E/61B1EDAC" Ref="U?"  Part="2" 
F 0 "U?" H 1350 3300 50  0000 C CNN
F 1 "74LS74" H 1400 2800 50  0000 C CNN
F 2 "" H 1250 3050 50  0001 C CNN
F 3 "74xx/74hc_hct74.pdf" H 1250 3050 50  0001 C CNN
	2    1250 3050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 61B2A1CC
P 7800 2450
AR Path="/61B2A1CC" Ref="#PWR?"  Part="1" 
AR Path="/61AEA36E/61B2A1CC" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 7800 2200 50  0001 C CNN
F 1 "GND" H 7805 2277 50  0000 C CNN
F 2 "" H 7800 2450 50  0001 C CNN
F 3 "" H 7800 2450 50  0001 C CNN
	1    7800 2450
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
Text GLabel 950  2950 0    50   Input ~ 0
D7
Text GLabel 950  3050 0    50   Input ~ 0
BZRWR
$Comp
L Connector:Conn_01x02_Male J?
U 1 1 61B45D9D
P 2000 3050
F 0 "J?" H 1972 2932 50  0000 R CNN
F 1 "Conn_01x02_Male" H 1972 3023 50  0000 R CNN
F 2 "" H 2000 3050 50  0001 C CNN
F 3 "~" H 2000 3050 50  0001 C CNN
	1    2000 3050
	-1   0    0    1   
$EndComp
Wire Wire Line
	1800 2950 1550 2950
$Comp
L power:GND #PWR?
U 1 1 61B4867B
P 1800 3050
F 0 "#PWR?" H 1800 2800 50  0001 C CNN
F 1 "GND" H 1805 2877 50  0000 C CNN
F 2 "" H 1800 3050 50  0001 C CNN
F 3 "" H 1800 3050 50  0001 C CNN
	1    1800 3050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 61B48E69
P 1250 3350
F 0 "#PWR?" H 1250 3100 50  0001 C CNN
F 1 "GND" H 1255 3177 50  0000 C CNN
F 2 "" H 1250 3350 50  0001 C CNN
F 3 "" H 1250 3350 50  0001 C CNN
	1    1250 3350
	1    0    0    -1  
$EndComp
Text GLabel 4050 5350 3    50   Input ~ 0
R1
Text GLabel 3950 5350 3    50   Input ~ 0
R2
Text GLabel 3850 5350 3    50   Input ~ 0
R3
Text GLabel 3750 5350 3    50   Input ~ 0
C0
Text GLabel 3650 5350 3    50   Input ~ 0
C1
Text GLabel 3550 5350 3    50   Input ~ 0
C2
Text GLabel 3450 5350 3    50   Input ~ 0
C3
Text GLabel 3350 5350 3    50   Input ~ 0
C4
Text GLabel 3250 5350 3    50   Input ~ 0
C5
Text GLabel 3150 5350 3    50   Input ~ 0
C6
Text GLabel 3050 5350 3    50   Input ~ 0
C7
Text GLabel 2950 5350 3    50   Input ~ 0
ALT
Text GLabel 2850 5350 3    50   Input ~ 0
SHIFT
$Comp
L power:GND #PWR?
U 1 1 618D7FD6
P 2650 5350
F 0 "#PWR?" H 2650 5100 50  0001 C CNN
F 1 "GND" H 2655 5177 50  0000 C CNN
F 2 "" H 2650 5350 50  0001 C CNN
F 3 "" H 2650 5350 50  0001 C CNN
	1    2650 5350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 618D877B
P 2400 5150
F 0 "#PWR?" H 2400 5000 50  0001 C CNN
F 1 "+5V" H 2415 5323 50  0000 C CNN
F 2 "" H 2400 5150 50  0001 C CNN
F 3 "" H 2400 5150 50  0001 C CNN
	1    2400 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 5150 2400 5700
Wire Wire Line
	2400 5700 2750 5700
Wire Wire Line
	2750 5700 2750 5350
$Comp
L power:+5V #PWR?
U 1 1 618DBCE9
P 1250 2750
F 0 "#PWR?" H 1250 2600 50  0001 C CNN
F 1 "+5V" H 1265 2923 50  0000 C CNN
F 2 "" H 1250 2750 50  0001 C CNN
F 3 "" H 1250 2750 50  0001 C CNN
	1    1250 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 618DC375
P 7300 2800
F 0 "#PWR?" H 7300 2650 50  0001 C CNN
F 1 "+5V" H 7400 2800 50  0000 C CNN
F 2 "" H 7300 2800 50  0001 C CNN
F 3 "" H 7300 2800 50  0001 C CNN
	1    7300 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 1050 3600 1750
Wire Wire Line
	3600 1750 3850 1750
Wire Wire Line
	3600 1050 3850 1050
Wire Wire Line
	3600 1750 3600 2200
Connection ~ 3600 1750
Wire Wire Line
	4250 2300 4250 2200
Wire Wire Line
	3600 2200 4250 2200
Connection ~ 4250 2200
Wire Wire Line
	4250 2200 4250 2150
Wire Wire Line
	4250 850  4250 800 
Wire Wire Line
	4250 800  3400 800 
Wire Wire Line
	3400 800  3400 1550
Wire Wire Line
	3400 1550 3850 1550
Connection ~ 4250 800 
Wire Wire Line
	4250 800  4250 750 
Wire Wire Line
	3850 1250 3850 1350
Wire Wire Line
	3850 1200 3850 1250
Connection ~ 3850 1250
Wire Wire Line
	3850 1250 3200 1250
NoConn ~ 4650 1950
$Comp
L Device:R_Small R?
U 1 1 618CDBF7
P 8450 3550
F 0 "R?" H 8509 3596 50  0000 L CNN
F 1 "R_Small" H 8509 3505 50  0000 L CNN
F 2 "" H 8450 3550 50  0001 C CNN
F 3 "~" H 8450 3550 50  0001 C CNN
	1    8450 3550
	1    0    0    -1  
$EndComp
$Comp
L pspice:C C?
U 1 1 618CE1F3
P 8450 4050
F 0 "C?" H 8628 4096 50  0000 L CNN
F 1 "C" H 8628 4005 50  0000 L CNN
F 2 "" H 8450 4050 50  0001 C CNN
F 3 "~" H 8450 4050 50  0001 C CNN
	1    8450 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 3650 8450 3750
$Comp
L power:GND #PWR?
U 1 1 618D22EE
P 8450 4750
F 0 "#PWR?" H 8450 4500 50  0001 C CNN
F 1 "GND" H 8455 4577 50  0000 C CNN
F 2 "" H 8450 4750 50  0001 C CNN
F 3 "" H 8450 4750 50  0001 C CNN
	1    8450 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 4300 8450 4750
Wire Wire Line
	8450 3750 9050 3750
Connection ~ 8450 3750
Wire Wire Line
	8450 3750 8450 3800
$Comp
L 74xx:74LS14 U?
U 1 1 618D95DD
P 9350 3750
F 0 "U?" H 9350 4067 50  0000 C CNN
F 1 "74LS14" H 9350 3976 50  0000 C CNN
F 2 "" H 9350 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 9350 3750 50  0001 C CNN
	1    9350 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 3100 8450 3100
Wire Wire Line
	8450 3100 8450 3450
Wire Wire Line
	5000 4000 6800 4000
Wire Wire Line
	4900 4100 6800 4100
Wire Wire Line
	6800 3100 6150 3100
Wire Wire Line
	6800 3200 6250 3200
Wire Wire Line
	6800 3300 6350 3300
Wire Wire Line
	6800 3400 6450 3400
$Comp
L Device:R R?
U 1 1 618C2CE1
P 6150 3700
F 0 "R?" H 6150 3850 50  0000 L CNN
F 1 "R" H 6150 3650 50  0000 L CNN
F 2 "" V 6080 3700 50  0001 C CNN
F 3 "~" H 6150 3700 50  0001 C CNN
	1    6150 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 618C2F61
P 6250 3700
F 0 "R?" H 6250 3850 50  0000 L CNN
F 1 "R" H 6250 3650 50  0000 L CNN
F 2 "" V 6180 3700 50  0001 C CNN
F 3 "~" H 6250 3700 50  0001 C CNN
	1    6250 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 618C371B
P 6450 3700
F 0 "R?" H 6450 3850 50  0000 L CNN
F 1 "R" H 6450 3650 50  0000 L CNN
F 2 "" V 6380 3700 50  0001 C CNN
F 3 "~" H 6450 3700 50  0001 C CNN
	1    6450 3700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 618C4C5A
P 6350 3700
F 0 "R?" H 6350 3850 50  0000 L CNN
F 1 "R" H 6350 3650 50  0000 L CNN
F 2 "" V 6280 3700 50  0001 C CNN
F 3 "~" H 6350 3700 50  0001 C CNN
	1    6350 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	6150 3550 6150 3100
Connection ~ 6150 3100
Wire Wire Line
	6150 3100 6050 3100
Wire Wire Line
	6250 3550 6250 3200
Connection ~ 6250 3200
Wire Wire Line
	6250 3200 6050 3200
Wire Wire Line
	6350 3550 6350 3300
Connection ~ 6350 3300
Wire Wire Line
	6350 3300 6050 3300
Wire Wire Line
	6450 3550 6450 3400
Connection ~ 6450 3400
Wire Wire Line
	6450 3400 6050 3400
Wire Wire Line
	6150 3850 6250 3850
Wire Wire Line
	6450 3850 6450 4750
Wire Wire Line
	6450 4750 6800 4750
Connection ~ 6450 3850
Connection ~ 6250 3850
Wire Wire Line
	6250 3850 6350 3850
Connection ~ 6350 3850
Wire Wire Line
	6350 3850 6450 3850
Connection ~ 6800 4750
Text GLabel 8650 3100 2    50   Input ~ 0
LOAD
Wire Wire Line
	8650 3100 8450 3100
Connection ~ 8450 3100
Text GLabel 5550 2650 3    50   Input ~ 0
LOAD
Wire Wire Line
	5550 2650 5550 1950
Wire Wire Line
	5550 1950 5650 1950
$Comp
L 74xx:74LS32 U?
U 1 1 618ED8CC
P 2900 1250
F 0 "U?" H 2900 1575 50  0000 C CNN
F 1 "74LS32" H 2900 1484 50  0000 C CNN
F 2 "" H 2900 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2900 1250 50  0001 C CNN
	1    2900 1250
	1    0    0    -1  
$EndComp
Text GLabel 900  1350 0    50   Input ~ 0
CLK
Wire Wire Line
	900  1350 2600 1350
Text GLabel 2450 1150 0    50   Input ~ 0
LOAD
Wire Wire Line
	2600 1150 2450 1150
Wire Wire Line
	9850 4750 10050 4750
$Comp
L 74xx:74LS14 U?
U 2 1 61948336
P 10550 3200
F 0 "U?" V 10596 3020 50  0000 R CNN
F 1 "74LS14" V 10505 3020 50  0000 R CNN
F 2 "" H 10550 3200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS14" H 10550 3200 50  0001 C CNN
	2    10550 3200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	10450 3650 10550 3650
Wire Wire Line
	10550 3650 10550 3500
Text GLabel 10550 2900 1    50   Input ~ 0
INT
$EndSCHEMATC
