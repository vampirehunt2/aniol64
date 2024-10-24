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
L MCU_Intel:8088 U?
U 1 1 633D53C3
P 2450 2950
F 0 "U?" H 2450 4931 50  0000 C CNN
F 1 "8088" H 2450 4840 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm" H 2500 3050 50  0001 C CIN
F 3 "http://datasheets.chipdb.org/Intel/x86/808x/datashts/8088/231456-006.pdf" H 2450 3000 50  0001 C CNN
	1    2450 2950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HCT574 U?
U 1 1 633D630F
P 4700 2300
F 0 "U?" H 4700 3281 50  0000 C CNN
F 1 "74HCT574" H 4700 3190 50  0000 C CNN
F 2 "" H 4700 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HCT574" H 4700 2300 50  0001 C CNN
	1    4700 2300
	1    0    0    -1  
$EndComp
$Comp
L Logic_Programmable:GAL16V8 U?
U 1 1 633D6C22
P 2550 5800
F 0 "U?" H 2550 6681 50  0000 C CNN
F 1 "GAL16V8" H 2550 6590 50  0000 C CNN
F 2 "" H 2550 5800 50  0001 C CNN
F 3 "" H 2550 5800 50  0001 C CNN
	1    2550 5800
	-1   0    0    -1  
$EndComp
$Comp
L Memory_RAM:AS6C4008-55PCN U?
U 1 1 633DBDEF
P 6900 4800
F 0 "U?" H 6900 6081 50  0000 C CNN
F 1 "AS6C4008-55PCN" H 6900 5990 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 6900 4900 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C4008.pdf" H 6900 4900 50  0001 C CNN
	1    6900 4800
	1    0    0    -1  
$EndComp
$Comp
L memory:27C010 U?
U 1 1 633DCA4A
P 6900 1850
F 0 "U?" H 6900 3071 70  0000 C CNN
F 1 "27C010" H 6900 2950 70  0000 C CNN
F 2 "" H 6900 1850 50  0001 C CNN
F 3 "" H 6900 1850 50  0001 C CNN
	1    6900 1850
	1    0    0    -1  
$EndComp
$Comp
L Interface_UART:8252 U?
U 1 1 633DE711
P 4300 6200
F 0 "U?" H 4300 7481 50  0000 C CNN
F 1 "8252" H 4300 7390 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 4300 6200 50  0001 C CIN
F 3 "" H 4300 6200 50  0001 C CNN
	1    4300 6200
	1    0    0    -1  
$EndComp
Entry Wire Line
	3300 1750 3200 1850
Entry Wire Line
	3300 1850 3200 1950
Entry Wire Line
	3300 1950 3200 2050
Entry Wire Line
	3300 2050 3200 2150
Entry Wire Line
	3300 2150 3200 2250
Entry Wire Line
	3300 2250 3200 2350
Entry Wire Line
	3300 2350 3200 2450
Entry Wire Line
	3300 2450 3200 2550
Wire Wire Line
	3200 1850 3150 1850
Wire Wire Line
	3200 1950 3150 1950
Wire Wire Line
	3200 2050 3150 2050
Wire Wire Line
	3200 2150 3150 2150
Wire Wire Line
	3200 2250 3150 2250
Wire Wire Line
	3200 2350 3150 2350
Wire Wire Line
	3200 2450 3150 2450
Wire Wire Line
	3200 2550 3150 2550
Entry Wire Line
	4050 2400 4150 2500
Entry Wire Line
	4050 2300 4150 2400
Entry Wire Line
	4050 2200 4150 2300
Entry Wire Line
	4050 2100 4150 2200
Entry Wire Line
	4050 2000 4150 2100
Entry Wire Line
	4050 1900 4150 2000
Entry Wire Line
	4050 1800 4150 1900
Entry Wire Line
	4050 1700 4150 1800
Wire Wire Line
	4200 1800 4150 1800
Wire Wire Line
	4200 1900 4150 1900
Wire Wire Line
	4200 2000 4150 2000
Wire Wire Line
	4200 2100 4150 2100
Wire Wire Line
	4200 2200 4150 2200
Wire Wire Line
	4200 2300 4150 2300
Wire Wire Line
	4200 2400 4150 2400
Wire Wire Line
	4200 2500 4150 2500
Entry Wire Line
	3300 2650 3200 2750
Entry Wire Line
	3300 2750 3200 2850
Entry Wire Line
	3300 2850 3200 2950
Entry Wire Line
	3300 2950 3200 3050
Entry Wire Line
	3300 3050 3200 3150
Entry Wire Line
	3300 3150 3200 3250
Entry Wire Line
	3300 3250 3200 3350
Entry Wire Line
	3300 3350 3200 3450
Entry Wire Line
	3300 3550 3200 3650
Entry Wire Line
	3300 3650 3200 3750
Entry Wire Line
	3300 3750 3200 3850
Entry Wire Line
	3300 3850 3200 3950
Wire Wire Line
	3200 2750 3150 2750
Wire Wire Line
	3200 2850 3150 2850
Wire Wire Line
	3200 2950 3150 2950
Wire Wire Line
	3200 3050 3150 3050
Wire Wire Line
	3200 3150 3150 3150
Wire Wire Line
	3200 3250 3150 3250
Wire Wire Line
	3200 3350 3150 3350
Wire Wire Line
	3200 3450 3150 3450
Wire Wire Line
	3200 3650 3150 3650
Wire Wire Line
	3200 3750 3150 3750
Wire Wire Line
	3200 3850 3150 3850
Wire Wire Line
	3200 3950 3150 3950
Entry Wire Line
	5400 1700 5300 1800
Entry Wire Line
	5400 1800 5300 1900
Entry Wire Line
	5400 1900 5300 2000
Entry Wire Line
	5400 2000 5300 2100
Entry Wire Line
	5400 2100 5300 2200
Entry Wire Line
	5400 2200 5300 2300
Entry Wire Line
	5400 2300 5300 2400
Entry Wire Line
	5400 2400 5300 2500
Wire Wire Line
	5300 1800 5200 1800
Wire Wire Line
	5300 1900 5200 1900
Wire Wire Line
	5300 2000 5200 2000
Wire Wire Line
	5300 2100 5200 2100
Wire Wire Line
	5300 2200 5200 2200
Wire Wire Line
	5300 2300 5200 2300
Wire Wire Line
	5300 2400 5200 2400
Wire Wire Line
	5300 2500 5200 2500
Entry Wire Line
	6000 850  6100 950 
Entry Wire Line
	6000 950  6100 1050
Entry Wire Line
	6000 1050 6100 1150
Entry Wire Line
	6000 1150 6100 1250
Entry Wire Line
	6000 1250 6100 1350
Entry Wire Line
	6000 1350 6100 1450
Entry Wire Line
	6000 1450 6100 1550
Entry Wire Line
	6000 1550 6100 1650
Entry Wire Line
	6000 1650 6100 1750
Entry Wire Line
	6000 1750 6100 1850
Entry Wire Line
	6000 1850 6100 1950
Entry Wire Line
	6000 1950 6100 2050
Entry Wire Line
	6000 2050 6100 2150
Entry Wire Line
	6000 2150 6100 2250
Entry Wire Line
	6000 2250 6100 2350
Entry Wire Line
	6000 2350 6100 2450
Entry Wire Line
	6000 2450 6100 2550
Wire Wire Line
	6200 2550 6100 2550
Wire Wire Line
	6200 2450 6100 2450
Wire Wire Line
	6200 2350 6100 2350
Wire Wire Line
	6200 2250 6100 2250
Wire Wire Line
	6200 2150 6100 2150
Wire Wire Line
	6200 2050 6100 2050
Wire Wire Line
	6200 1950 6100 1950
Wire Wire Line
	6200 1850 6100 1850
Wire Wire Line
	6200 1750 6100 1750
Wire Wire Line
	6200 1650 6100 1650
Wire Wire Line
	6200 1550 6100 1550
Wire Wire Line
	6200 1450 6100 1450
Wire Wire Line
	6200 1350 6100 1350
Wire Wire Line
	6200 1250 6100 1250
Wire Wire Line
	6200 1150 6100 1150
Wire Wire Line
	6200 1050 6100 1050
Wire Wire Line
	6200 950  6100 950 
Connection ~ 5400 650 
Wire Bus Line
	5400 650  6000 650 
Connection ~ 6000 650 
Wire Bus Line
	6000 650  7800 650 
Wire Bus Line
	3300 650  4050 650 
Connection ~ 4050 650 
Wire Bus Line
	4050 650  5400 650 
Entry Wire Line
	6000 3800 6100 3900
Entry Wire Line
	6000 3900 6100 4000
Entry Wire Line
	6000 4000 6100 4100
Entry Wire Line
	6000 4100 6100 4200
Entry Wire Line
	6000 4200 6100 4300
Entry Wire Line
	6000 4300 6100 4400
Entry Wire Line
	6000 4400 6100 4500
Entry Wire Line
	6000 4500 6100 4600
Entry Wire Line
	6000 4600 6100 4700
Entry Wire Line
	6000 4700 6100 4800
Entry Wire Line
	6000 4800 6100 4900
Entry Wire Line
	6000 4900 6100 5000
Entry Wire Line
	6000 5000 6100 5100
Entry Wire Line
	6000 5100 6100 5200
Entry Wire Line
	6000 5200 6100 5300
Entry Wire Line
	6000 5300 6100 5400
Entry Wire Line
	6000 5400 6100 5500
Entry Wire Line
	6000 5500 6100 5600
Entry Wire Line
	6000 5600 6100 5700
Wire Wire Line
	6400 5700 6100 5700
Wire Wire Line
	6400 5600 6100 5600
Wire Wire Line
	6400 5500 6100 5500
Wire Wire Line
	6400 5400 6100 5400
Wire Wire Line
	6400 5300 6100 5300
Wire Wire Line
	6400 5200 6100 5200
Wire Wire Line
	6400 5100 6100 5100
Wire Wire Line
	6400 5000 6100 5000
Wire Wire Line
	6400 4900 6100 4900
Wire Wire Line
	6400 4800 6100 4800
Wire Wire Line
	6400 4700 6100 4700
Wire Wire Line
	6400 4600 6100 4600
Wire Wire Line
	6400 4500 6100 4500
Wire Wire Line
	6400 4400 6100 4400
Wire Wire Line
	6400 4300 6100 4300
Wire Wire Line
	6400 4200 6100 4200
Wire Wire Line
	6400 4100 6100 4100
Wire Wire Line
	6400 4000 6100 4000
Wire Wire Line
	6400 3900 6100 3900
Entry Wire Line
	7700 950  7800 1050
Entry Wire Line
	7700 1050 7800 1150
Entry Wire Line
	7700 1150 7800 1250
Entry Wire Line
	7700 1250 7800 1350
Entry Wire Line
	7700 1350 7800 1450
Entry Wire Line
	7700 1450 7800 1550
Entry Wire Line
	7700 1550 7800 1650
Entry Wire Line
	7700 1650 7800 1750
Entry Wire Line
	7700 3900 7800 4000
Entry Wire Line
	7700 4000 7800 4100
Entry Wire Line
	7700 4100 7800 4200
Entry Wire Line
	7700 4200 7800 4300
Entry Wire Line
	7700 4300 7800 4400
Entry Wire Line
	7700 4400 7800 4500
Entry Wire Line
	7700 4500 7800 4600
Entry Wire Line
	7700 4600 7800 4700
Wire Wire Line
	7700 4600 7400 4600
Wire Wire Line
	7700 4500 7400 4500
Wire Wire Line
	7700 4400 7400 4400
Wire Wire Line
	7700 4300 7400 4300
Wire Wire Line
	7700 4200 7400 4200
Wire Wire Line
	7700 4100 7400 4100
Wire Wire Line
	7700 4000 7400 4000
Wire Wire Line
	7700 3900 7400 3900
Wire Wire Line
	7700 950  7600 950 
Wire Wire Line
	7700 1050 7600 1050
Wire Wire Line
	7700 1150 7600 1150
Wire Wire Line
	7700 1250 7600 1250
Wire Wire Line
	7700 1350 7600 1350
Wire Wire Line
	7700 1450 7600 1450
Wire Wire Line
	7700 1550 7600 1550
Wire Wire Line
	7700 1650 7600 1650
Entry Wire Line
	3300 5300 3400 5400
Entry Wire Line
	3300 5400 3400 5500
Entry Wire Line
	3300 5500 3400 5600
Entry Wire Line
	3300 5600 3400 5700
Entry Wire Line
	3300 5700 3400 5800
Entry Wire Line
	3300 5800 3400 5900
Entry Wire Line
	3300 5900 3400 6000
Entry Wire Line
	3300 6000 3400 6100
Wire Wire Line
	3600 5400 3400 5400
Wire Wire Line
	3600 5500 3400 5500
Wire Wire Line
	3600 5600 3400 5600
Wire Wire Line
	3600 5700 3400 5700
Wire Wire Line
	3600 5800 3400 5800
Wire Wire Line
	3600 5900 3400 5900
Wire Wire Line
	3600 6000 3400 6000
Wire Wire Line
	3600 6100 3400 6100
Wire Wire Line
	3150 1650 3700 1650
Wire Wire Line
	3700 1650 3700 2700
Wire Wire Line
	3700 2700 4200 2700
Wire Wire Line
	4200 2800 4200 3100
Wire Wire Line
	4200 3100 4700 3100
Text Label 3200 1850 0    50   ~ 0
D0
Text Label 3200 1950 0    50   ~ 0
D1
Text Label 3200 2050 0    50   ~ 0
D2
Text Label 3200 2150 0    50   ~ 0
D3
Text Label 3200 2250 0    50   ~ 0
D4
Text Label 3200 2350 0    50   ~ 0
D5
Text Label 3200 2450 0    50   ~ 0
D6
Text Label 3200 2550 0    50   ~ 0
D7
Text Label 3200 2750 0    50   ~ 0
A8
Text Label 3200 2850 0    50   ~ 0
A9
Text Label 3200 2950 0    50   ~ 0
A10
Text Label 3200 3050 0    50   ~ 0
A11
Text Label 3200 3150 0    50   ~ 0
A12
Text Label 3200 3250 0    50   ~ 0
A13
Text Label 3200 3350 0    50   ~ 0
A14
Text Label 3200 3450 0    50   ~ 0
A15
Text Label 3200 3650 0    50   ~ 0
A16
Text Label 3200 3750 0    50   ~ 0
A17
Text Label 3200 3850 0    50   ~ 0
A18
Text Label 3200 3950 0    50   ~ 0
A19
Text Label 4100 1750 0    50   ~ 0
D0
Text Label 4100 1850 0    50   ~ 0
D1
Text Label 4100 1950 0    50   ~ 0
D2
Text Label 4100 2050 0    50   ~ 0
D3
Text Label 4100 2150 0    50   ~ 0
D4
Text Label 4100 2250 0    50   ~ 0
D5
Text Label 4100 2350 0    50   ~ 0
D6
Text Label 4100 2450 0    50   ~ 0
D7
Text Label 5300 1800 0    50   ~ 0
A0
Text Label 5300 1900 0    50   ~ 0
A1
Text Label 5300 2000 0    50   ~ 0
A2
Text Label 5300 2100 0    50   ~ 0
A3
Text Label 5300 2200 0    50   ~ 0
A4
Text Label 5300 2300 0    50   ~ 0
A5
Text Label 5300 2400 0    50   ~ 0
A6
Text Label 5300 2500 0    50   ~ 0
A7
Text Label 6050 900  0    50   ~ 0
A0
Text Label 6050 1000 0    50   ~ 0
A1
Text Label 6050 1100 0    50   ~ 0
A2
Text Label 6050 1200 0    50   ~ 0
A3
Text Label 6050 1300 0    50   ~ 0
A4
Text Label 6050 1400 0    50   ~ 0
A5
Text Label 6050 1500 0    50   ~ 0
A6
Text Label 6050 1600 0    50   ~ 0
A7
Text Label 6050 1700 0    50   ~ 0
A8
Text Label 6050 1800 0    50   ~ 0
A9
Text Label 6050 1900 0    50   ~ 0
A10
Text Label 6050 2000 0    50   ~ 0
A11
Text Label 6050 2100 0    50   ~ 0
A12
Text Label 6050 2200 0    50   ~ 0
A13
Text Label 6050 2300 0    50   ~ 0
A14
Text Label 6050 2400 0    50   ~ 0
A15
Text Label 6050 2500 0    50   ~ 0
A16
Text Label 7700 950  0    50   ~ 0
D0
Text Label 7700 1050 0    50   ~ 0
D1
Text Label 7700 1150 0    50   ~ 0
D2
Text Label 7700 1250 0    50   ~ 0
D3
Text Label 7700 1350 0    50   ~ 0
D4
Text Label 7700 1450 0    50   ~ 0
D5
Text Label 7700 1550 0    50   ~ 0
D6
Text Label 7700 1650 0    50   ~ 0
D7
Text Label 6050 3850 0    50   ~ 0
A0
Text Label 6050 3950 0    50   ~ 0
A1
Text Label 6050 4050 0    50   ~ 0
A2
Text Label 6050 4150 0    50   ~ 0
A3
Text Label 6050 4250 0    50   ~ 0
A4
Text Label 6050 4350 0    50   ~ 0
A5
Text Label 6050 4450 0    50   ~ 0
A6
Text Label 6050 4550 0    50   ~ 0
A7
Text Label 6050 4650 0    50   ~ 0
A8
Text Label 6050 4750 0    50   ~ 0
A9
Text Label 6050 4850 0    50   ~ 0
A10
Text Label 6050 4950 0    50   ~ 0
A11
Text Label 6050 5050 0    50   ~ 0
A12
Text Label 6050 5150 0    50   ~ 0
A13
Text Label 6050 5250 0    50   ~ 0
A14
Text Label 6050 5350 0    50   ~ 0
A15
Text Label 6050 5450 0    50   ~ 0
A16
Text Label 6050 5550 0    50   ~ 0
A17
Text Label 6050 5650 0    50   ~ 0
A18
Text Label 7700 3900 0    50   ~ 0
D0
Text Label 7700 4000 0    50   ~ 0
D1
Text Label 7700 4100 0    50   ~ 0
D2
Text Label 7700 4200 0    50   ~ 0
D3
Text Label 7700 4300 0    50   ~ 0
D4
Text Label 7700 4400 0    50   ~ 0
D5
Text Label 7700 4500 0    50   ~ 0
D6
Text Label 7700 4600 0    50   ~ 0
D7
Text Label 3350 5350 0    50   ~ 0
D0
Text Label 3350 5450 0    50   ~ 0
D1
Text Label 3350 5550 0    50   ~ 0
D2
Text Label 3350 5650 0    50   ~ 0
D3
Text Label 3350 5750 0    50   ~ 0
D4
Text Label 3350 5850 0    50   ~ 0
D5
Text Label 3350 5950 0    50   ~ 0
D6
Text Label 3350 6050 0    50   ~ 0
D7
Entry Wire Line
	3200 5300 3300 5400
Entry Wire Line
	3200 5400 3300 5500
Entry Wire Line
	3200 5500 3300 5600
Entry Wire Line
	3200 5600 3300 5700
Entry Wire Line
	3200 5700 3300 5800
Entry Wire Line
	3200 5800 3300 5900
Entry Wire Line
	3200 5900 3300 6000
Entry Wire Line
	3200 6000 3300 6100
Entry Wire Line
	3200 6100 3300 6200
Wire Wire Line
	3200 6100 3050 6100
Wire Wire Line
	3200 6000 3050 6000
Wire Wire Line
	3200 5900 3050 5900
Wire Wire Line
	3200 5800 3050 5800
Wire Wire Line
	3200 5700 3050 5700
Wire Wire Line
	3200 5600 3050 5600
Wire Wire Line
	3200 5500 3050 5500
Wire Wire Line
	3200 5400 3050 5400
Wire Wire Line
	3200 5300 3050 5300
Entry Wire Line
	3300 6300 3200 6200
Wire Wire Line
	3200 6200 3050 6200
Wire Bus Line
	5400 650  5400 2500
Wire Bus Line
	4050 650  4050 2500
Wire Bus Line
	7800 650  7800 4700
Wire Bus Line
	3300 650  3300 6300
Wire Bus Line
	6000 650  6000 5750
$EndSCHEMATC
