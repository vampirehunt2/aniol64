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
L z180:Z8-L180-S180-180-PLCC-68 IC1
U 1 1 636BD5D9
P 1850 3750
F 0 "IC1" H 3894 2771 50  0000 L CNN
F 1 "Z8-L180-S180-180-PLCC-68" H 3894 2680 50  0000 L CNN
F 2 "Package_LCC:PLCC-68" H 1850 4750 50  0001 L CNN
F 3 "" H 3200 3650 50  0001 L CNN
F 4 "Zilog Z8S180 & Z8L180, Z80 Microprocessor Z180 8bit CISC 68-Pin PLCC" H 1850 5175 50  0001 L CNN "Description"
F 5 "4.57" H 3200 4750 50  0001 L CNN "Height"
F 6 "Zilog" H 3150 4650 50  0001 L CNN "Manufacturer_Name"
F 7 "Z8S18033VSG" H 1850 4650 50  0001 L CNN "Manufacturer_Part_Number"
F 8 "692-Z8S18033VSG" H 1850 4550 50  0001 L CNN "Mouser Part Number"
F 9 "https://www.mouser.com/Search/Refine.aspx?Keyword=692-Z8S18033VSG" H 1850 5075 50  0001 L CNN "Mouser Price/Stock"
F 10 "6259270" H 3200 4550 50  0001 L CNN "RS Part Number"
F 11 "http://uk.rs-online.com/web/p/products/6259270" H 1850 4975 50  0001 L CNN "RS Price/Stock"
F 12 "R1000023" H 3150 4450 50  0001 L CNN "Allied_Number"
F 13 "https://www.alliedelec.com/zilog-z8s18033vsg/R1000023/" H 1850 4875 50  0001 L CNN "Allied Price/Stock"
	1    1850 3750
	1    0    0    -1  
$EndComp
$Comp
L Memory_RAM:AS6C4008-55PCN U3
U 1 1 636BF444
P 6300 4800
F 0 "U3" H 6300 6081 50  0000 C CNN
F 1 "AS6C4008-55PCN" H 6300 5990 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 6300 4900 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C4008.pdf" H 6300 4900 50  0001 C CNN
	1    6300 4800
	1    0    0    -1  
$EndComp
$Comp
L memory:27C010 U4
U 1 1 636BFF94
P 8650 4600
F 0 "U4" H 8650 5821 70  0000 C CNN
F 1 "27C010" H 8650 5700 70  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 8650 4600 50  0001 C CNN
F 3 "" H 8650 4600 50  0001 C CNN
	1    8650 4600
	1    0    0    -1  
$EndComp
$Comp
L Logic_Programmable:GAL16V8 U1
U 1 1 636C0B21
P 2050 2700
F 0 "U1" V 2004 3444 50  0000 L CNN
F 1 "GAL16V8" V 2095 3444 50  0000 L CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket" H 2050 2700 50  0001 C CNN
F 3 "" H 2050 2700 50  0001 C CNN
	1    2050 2700
	0    1    1    0   
$EndComp
$Comp
L MCU_Microchip_ATmega:ATmega8A-PU U2
U 1 1 636C1AC2
P 5450 2700
F 0 "U2" V 5404 4144 50  0000 L CNN
F 1 "ATmega8A-PU" V 5495 4144 50  0000 L CNN
F 2 "Package_DIP:DIP-28_W7.62mm" H 5450 2700 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/Microchip%208bit%20mcu%20AVR%20ATmega8A%20data%20sheet%2040001974A.pdf" H 5450 2700 50  0001 C CNN
	1    5450 2700
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_Coaxial J2
U 1 1 636C4E87
P 1750 900
F 0 "J2" H 1850 875 50  0000 L CNN
F 1 "Conn_Coaxial" H 1850 784 50  0000 L CNN
F 2 "Connector_Coaxial:SMA_Amphenol_132203-12_Horizontal" H 1750 900 50  0001 C CNN
F 3 " ~" H 1750 900 50  0001 C CNN
	1    1750 900 
	1    0    0    -1  
$EndComp
$Comp
L Connector:Barrel_Jack J1
U 1 1 636C588F
P 1100 1000
F 0 "J1" H 1157 1325 50  0000 C CNN
F 1 "Barrel_Jack" H 1157 1234 50  0000 C CNN
F 2 "Connector_BarrelJack:BarrelJack_Horizontal" H 1150 960 50  0001 C CNN
F 3 "~" H 1150 960 50  0001 C CNN
	1    1100 1000
	1    0    0    -1  
$EndComp
$Comp
L Connector:Mini-DIN-6 J4
U 1 1 636C6199
P 3350 1000
F 0 "J4" H 3350 1367 50  0000 C CNN
F 1 "Mini-DIN-6" H 3350 1276 50  0000 C CNN
F 2 "" H 3350 1000 50  0001 C CNN
F 3 "http://service.powerdynamics.com/ec/Catalog17/Section%2011.pdf" H 3350 1000 50  0001 C CNN
	1    3350 1000
	1    0    0    -1  
$EndComp
$Comp
L Connector:Mini-DIN-6 J3
U 1 1 636C73EE
P 2450 1000
F 0 "J3" H 2450 1367 50  0000 C CNN
F 1 "Mini-DIN-6" H 2450 1276 50  0000 C CNN
F 2 "" H 2450 1000 50  0001 C CNN
F 3 "http://service.powerdynamics.com/ec/Catalog17/Section%2011.pdf" H 2450 1000 50  0001 C CNN
	1    2450 1000
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J5
U 1 1 636CAAC0
P 5150 1550
F 0 "J5" V 5154 463 50  0000 R CNN
F 1 "Conn_02x20_Odd_Even" V 5245 463 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x20_P2.54mm_Vertical_SMD" H 5150 1550 50  0001 C CNN
F 3 "~" H 5150 1550 50  0001 C CNN
	1    5150 1550
	0    1    1    0   
$EndComp
$Comp
L pspice:CAP C1
U 1 1 636CBA8B
P 1050 1650
F 0 "C1" H 1228 1696 50  0000 L CNN
F 1 "CAP" H 1228 1605 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D10.0mm_P5.00mm_P7.50mm" H 1050 1650 50  0001 C CNN
F 3 "~" H 1050 1650 50  0001 C CNN
	1    1050 1650
	1    0    0    -1  
$EndComp
$Comp
L Device:Crystal Y1
U 1 1 636CC068
P 900 3750
F 0 "Y1" H 900 4018 50  0000 C CNN
F 1 "Crystal" H 900 3927 50  0000 C CNN
F 2 "Crystal:Crystal_AT310_D3.0mm_L10.0mm_Vertical" H 900 3750 50  0001 C CNN
F 3 "~" H 900 3750 50  0001 C CNN
	1    900  3750
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x24_Male J6
U 1 1 636F162E
P 5250 800
F 0 "J6" V 5085 728 50  0000 C CNN
F 1 "Conn_01x24_Male" V 5176 728 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x24_P2.54mm_Horizontal" H 5250 800 50  0001 C CNN
F 3 "~" H 5250 800 50  0001 C CNN
	1    5250 800 
	0    1    1    0   
$EndComp
$EndSCHEMATC
