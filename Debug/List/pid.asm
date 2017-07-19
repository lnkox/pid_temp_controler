
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  _pin_change_isr0
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x74,0x65,0x6D,0x70,0x31,0x3D,0x25,0x69
	.DB  0x20,0x20,0x0,0x74,0x65,0x6D,0x70,0x32
	.DB  0x3D,0x25,0x69,0x20,0x20,0x0,0x74,0x65
	.DB  0x6D,0x70,0x33,0x3D,0x25,0x69,0x20,0x20
	.DB  0x0,0x74,0x65,0x6D,0x70,0x34,0x3D,0x25
	.DB  0x69,0x20,0xA,0xD,0x0,0x73,0x74,0x61
	.DB  0x72,0x74,0x20,0xA,0xD,0x0,0x72,0x65
	.DB  0x66,0x65,0x72,0x65,0x6E,0x63,0x65,0x56
	.DB  0x61,0x6C,0x75,0x65,0x3D,0x25,0x69,0x20
	.DB  0x20,0x0,0x6D,0x65,0x61,0x73,0x75,0x72
	.DB  0x65,0x6D,0x65,0x6E,0x74,0x56,0x61,0x6C
	.DB  0x75,0x65,0x3D,0x25,0x69,0x20,0x20,0x0
	.DB  0x69,0x6E,0x70,0x75,0x74,0x56,0x61,0x6C
	.DB  0x75,0x65,0x3D,0x25,0x69,0x20,0xA,0xD
	.DB  0x0
__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#define zero_1 PINB.5
;#define zero_2 PINB.4
;#define zero_3 PINB.3
;
;#define sem_1 PORTC.2
;#define sem_2 PORTC.1
;#define sem_3 PORTC.0
;
;
;#define mode_0 PIND.5
;#define mode_1 PIND.4
;#define mode_2 PIND.3
;#define mode_3 PIND.2
;
;#define t1_port PORTD.6
;#define t1_pin PIND.6
;#define t1_ddr DDRD.6
;#define t2_port PORTD.7
;#define t2_pin PIND.7
;#define t2_ddr DDRD.7
;#define t3_port PORTB.0
;#define t3_pin PINB.0
;#define t3_ddr DDRB.0
;#define t4_port PORTB.1
;#define t4_pin PINB.1
;#define t4_ddr DDRB.1
;
;#define fan PORTB.2
;
;
;#define K_P     1.00
;#define K_I     0.50
;#define K_D     0.30
;
;#include <mega328.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;#include "pidlib.h"
;/*This file has been prepared for Doxygen automatic documentation generation.*/
;/*! \file *********************************************************************
; *
; * \brief General PID implementation for AVR.
; *
; * Discrete PID controller implementation. Set up by giving P/I/D terms
; * to Init_PID(), and uses a struct PID_DATA to store internal values.
; *
; * - File:               pid.c
; * - Compiler:           IAR EWAAVR 4.11A
; * - Supported devices:  All AVR devices can be used.
; * - AppNote:            AVR221 - Discrete PID controller
; *
; * \author               Atmel Corporation: http://www.atmel.com \n
; *                       Support email: avr@atmel.com
; *
; * $Name$
; * $Revision: 456 $
; * $RCSfile$
; * $Date: 2006-02-16 12:46:13 +0100 (to, 16 feb 2006) $
; *****************************************************************************/
;
;
;
;
;/*! \brief Initialisation of PID controller parameters.
; *
; *  Initialise the variables used by the PID algorithm.
; *
; *  \param p_factor  Proportional term.
; *  \param i_factor  Integral term.
; *  \param d_factor  Derivate term.
; *  \param pid  Struct with PID status.
; */
;void pid_Init(signed int p_factor, signed int i_factor, signed int d_factor, struct PID_DATA *pid)
; 0000 0027 // Set up PID controller parameters
;{

	.CSEG
_pid_Init:
; .FSTART _pid_Init
;  // Start values for PID controller
;  pid->sumError = 0;
	ST   -Y,R27
	ST   -Y,R26
;	p_factor -> Y+6
;	i_factor -> Y+4
;	d_factor -> Y+2
;	*pid -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	__GETD1N 0x0
	CALL __PUTDP1
;  pid->lastProcessValue = 0;
	LD   R26,Y
	LDD  R27,Y+1
	ST   X+,R30
	ST   X,R31
;  // Tuning constants for PID loop
;  pid->P_Factor = p_factor;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1SNS 0,6
;  pid->I_Factor = i_factor;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	__PUTW1SNS 0,8
;  pid->D_Factor = d_factor;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	__PUTW1SNS 0,10
;  // Limits to avoid overflow
;  pid->maxError = MAX_INT / (pid->P_Factor + 1);
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,6
	CALL __GETW1P
	ADIW R30,1
	LDI  R26,LOW(32767)
	LDI  R27,HIGH(32767)
	CALL __DIVW21
	__PUTW1SNS 0,12
;  pid->maxSumError = MAX_I_TERM / (pid->I_Factor + 1);
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,8
	CALL __GETW1P
	ADIW R30,1
	CALL __CWD1
	__GETD2N 0x3FFFFFFF
	CALL __DIVD21
	__PUTD1SNS 0,14
;}
	ADIW R28,8
	RET
; .FEND
;
;
;/*! \brief PID control algorithm.
; *
; *  Calculates output from setpoint, process value and PID status.
; *
; *  \param setPoint  Desired value.
; *  \param processValue  Measured value.
; *  \param pid_st  PID status struct.
; */
;signed int pid_Controller(signed int setPoint, signed int processValue, struct PID_DATA *pid_st)
;{
_pid_Controller:
; .FSTART _pid_Controller
;  signed int error, p_term, d_term;
;  signed long i_term, ret, temp;
;
;  error = setPoint - processValue;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
	CALL __SAVELOCR6
;	setPoint -> Y+22
;	processValue -> Y+20
;	*pid_st -> Y+18
;	error -> R16,R17
;	p_term -> R18,R19
;	d_term -> R20,R21
;	i_term -> Y+14
;	ret -> Y+10
;	temp -> Y+6
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
;
;  // Calculate Pterm and limit error overflow
;  if (error > pid_st->maxError){
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,12
	CALL __GETW1P
	CP   R30,R16
	CPC  R31,R17
	BRGE _0x3
;    p_term = MAX_INT;
	__GETWRN 18,19,32767
;  }
;  else if (error < -pid_st->maxError){
	RJMP _0x4
_0x3:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,12
	CALL __GETW1P
	CALL __ANEGW1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x5
;    p_term = -MAX_INT;
	__GETWRN 18,19,-32767
;  }
;  else{
	RJMP _0x6
_0x5:
;    p_term = pid_st->P_Factor * error;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Z+6
	LDD  R27,Z+7
	MOVW R30,R16
	CALL __MULW12
	MOVW R18,R30
;  }
_0x6:
_0x4:
;
;  // Calculate Iterm and limit integral runaway
;  temp = pid_st->sumError + error;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	__GETD2Z 2
	MOVW R30,R16
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 6
;  if(temp > pid_st->maxSumError){
	CALL SUBOPT_0x0
	__GETD2S 6
	CALL __CPD12
	BRGE _0x7
;    i_term = MAX_I_TERM;
	__GETD1N 0x3FFFFFFF
	CALL SUBOPT_0x1
;    pid_st->sumError = pid_st->maxSumError;
	CALL SUBOPT_0x2
;  }
;  else if(temp < -pid_st->maxSumError){
	RJMP _0x8
_0x7:
	CALL SUBOPT_0x0
	CALL __ANEGD1
	__GETD2S 6
	CALL __CPD21
	BRGE _0x9
;    i_term = -MAX_I_TERM;
	__GETD1N 0xC0000001
	CALL SUBOPT_0x1
;    pid_st->sumError = -pid_st->maxSumError;
	CALL __ANEGD1
	CALL SUBOPT_0x2
;  }
;  else{
	RJMP _0xA
_0x9:
;    pid_st->sumError = temp;
	__GETD1S 6
	CALL SUBOPT_0x2
;    i_term = pid_st->I_Factor * pid_st->sumError;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	__GETWRZ 0,1,8
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,2
	CALL __GETD1P
	MOVW R26,R0
	CALL __CWD2
	CALL __MULD12
	__PUTD1S 14
;  }
_0xA:
_0x8:
;
;  // Calculate Dterm
;  d_term = pid_st->D_Factor * (pid_st->lastProcessValue - processValue);
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	__GETWRZ 0,1,10
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL __GETW1P
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R0
	CALL __MULW12
	MOVW R20,R30
;
;  pid_st->lastProcessValue = processValue;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ST   X+,R30
	ST   X,R31
;
;  ret = (p_term + i_term + d_term) / SCALING_FACTOR;
	__GETD1S 14
	MOVW R26,R18
	CALL __CWD2
	CALL __ADDD21
	MOVW R30,R20
	CALL __CWD1
	CALL __ADDD21
	__GETD1N 0x80
	CALL __DIVD21
	__PUTD1S 10
;  if(ret > MAX_INT){
	__GETD2S 10
	__CPD2N 0x8000
	BRLT _0xB
;    ret = MAX_INT;
	__GETD1N 0x7FFF
	RJMP _0xA5
;  }
;  else if(ret < -MAX_INT){
_0xB:
	__GETD2S 10
	__CPD2N 0xFFFF8001
	BRGE _0xD
;    ret = -MAX_INT;
	__GETD1N 0xFFFF8001
_0xA5:
	__PUTD1S 10
;  }
;
;  return((signed int)ret);
_0xD:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __LOADLOCR6
	ADIW R28,24
	RET
;}
; .FEND
;
;/*! \brief Resets the integrator.
; *
; *  Calling this function will reset the integrator in the PID regulator.
; */
;void pid_Reset_Integrator(pidData_t *pid_st)
;{
;  pid_st->sumError = 0;
;	*pid_st -> Y+0
;}
;
;// Declare your global variables here
;
;
;volatile char delay_pow1=0,delay_pow2=0,delay_pow3=0;
;volatile char pow1=0,pow2=0,pow3=0;
;volatile int temp1,temp2,temp3,temp4;
;
;struct PID_DATA pidData;
;bit pid_frag=0;
;void Init_pid(void)
; 0000 0033 {
_Init_pid:
; .FSTART _Init_pid
; 0000 0034   pid_Init(K_P * SCALING_FACTOR, K_I * SCALING_FACTOR , K_D * SCALING_FACTOR , &pidData);
	__GETD1N 0x80
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x40
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x26
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pidData)
	LDI  R27,HIGH(_pidData)
	RCALL _pid_Init
; 0000 0035 }
	RET
; .FEND
;int w1_find(void)
; 0000 0037 {
_w1_find:
; .FSTART _w1_find
; 0000 0038     int device=0;
; 0000 0039     t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
	ST   -Y,R17
	ST   -Y,R16
;	device -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x3
; 0000 003A     t1_port=0; t2_port=0; t3_port=0; t4_port=0;
; 0000 003B     delay_us(485);
	__DELAY_USW 970
; 0000 003C     t1_ddr=0; t2_ddr=0; t3_ddr=0; t4_ddr=0;
	CBI  0xA,6
	CBI  0xA,7
	CBI  0x4,0
	CBI  0x4,1
; 0000 003D     delay_us(65);
	__DELAY_USB 173
; 0000 003E     device=device+!t1_port;
	LDI  R30,0
	SBIS 0xB,6
	LDI  R30,1
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 003F     device=device+!t2_port;
	LDI  R30,0
	SBIS 0xB,7
	LDI  R30,1
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 0040     device=device+!t3_port;
	LDI  R30,0
	SBIS 0x5,0
	LDI  R30,1
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 0041     device=device+!t4_port;
	LDI  R30,0
	SBIS 0x5,1
	LDI  R30,1
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 0042 	delay_us(420);
	__DELAY_USW 840
; 0000 0043 	return device;
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0044 }
; .FEND
;
;void w1_send(char cmd)
; 0000 0047 {
_w1_send:
; .FSTART _w1_send
; 0000 0048     unsigned char bitc=0;
; 0000 0049     #asm("cli") // запрещаем прерывания, что бы не было сбоев при передачи
	ST   -Y,R26
	ST   -Y,R17
;	cmd -> Y+1
;	bitc -> R17
	LDI  R17,0
	cli
; 0000 004A     for (bitc=0; bitc < 8; bitc++)
	LDI  R17,LOW(0)
_0x27:
	CPI  R17,8
	BRSH _0x28
; 0000 004B      {
; 0000 004C         if (cmd&0x01) // сравниваем младший бит
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	BREQ _0x29
; 0000 004D         {
; 0000 004E             t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
	CALL SUBOPT_0x3
; 0000 004F             t1_port=0; t2_port=0; t3_port=0; t4_port=0;
; 0000 0050             delay_us(15);
	__DELAY_USB 40
; 0000 0051             t1_port=1;t2_port=1;t3_port=1;t4_port=1;
	SBI  0xB,6
	SBI  0xB,7
	SBI  0x5,0
	SBI  0x5,1
; 0000 0052             delay_us(50);
	__DELAY_USB 133
; 0000 0053             t1_ddr=0;t2_ddr=0;t3_ddr=0;t4_ddr=0;
	RJMP _0xA6
; 0000 0054             delay_us(5);
; 0000 0055         }
; 0000 0056         else
_0x29:
; 0000 0057         {
; 0000 0058             t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
	CALL SUBOPT_0x3
; 0000 0059             t1_port=0; t2_port=0; t3_port=0; t4_port=0;
; 0000 005A             delay_us(65);
	__DELAY_USB 173
; 0000 005B             t1_ddr=0; t2_ddr=0; t3_ddr=0; t4_ddr=0;
_0xA6:
	CBI  0xA,6
	CBI  0xA,7
	CBI  0x4,0
	CBI  0x4,1
; 0000 005C             delay_us(5);
	__DELAY_USB 13
; 0000 005D         };
; 0000 005E         cmd=cmd>>1; //сдвигаем передаваемый байт данных на 1 в сторону младших разрядов
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
; 0000 005F         };
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 0060     #asm("sei")
	sei
; 0000 0061 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;
;char w1_readbyte(char n_ter)
; 0000 0065 {
_w1_readbyte:
; .FSTART _w1_readbyte
; 0000 0066     unsigned char bitc=0;// счетчик принятых байт
; 0000 0067     unsigned char res=0; // принятый байт
; 0000 0068     #asm("cli")
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	n_ter -> Y+2
;	bitc -> R17
;	res -> R16
	LDI  R17,0
	LDI  R16,0
	cli
; 0000 0069 
; 0000 006A     for (bitc=0; bitc < 8; bitc++)
	LDI  R17,LOW(0)
_0x64:
	CPI  R17,8
	BRSH _0x65
; 0000 006B         {
; 0000 006C         t1_ddr=1; t2_ddr=1; t3_ddr=1; t4_ddr=1;
	CALL SUBOPT_0x3
; 0000 006D         t1_port=0; t2_port=0; t3_port=0; t4_port=0;
; 0000 006E         delay_us(1);
	__DELAY_USB 3
; 0000 006F         t1_ddr=0;t2_ddr=0;t3_ddr=0;t4_ddr=0;
	CBI  0xA,6
	CBI  0xA,7
	CBI  0x4,0
	CBI  0x4,1
; 0000 0070         delay_us(14);     // ждем завершения переходных процессов
	__DELAY_USB 37
; 0000 0071 
; 0000 0072         if (t1_pin && n_ter==1){res=res|(1 << bitc);}
	SBIS 0x9,6
	RJMP _0x7F
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BREQ _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	CALL SUBOPT_0x4
; 0000 0073         if (t2_pin && n_ter==2){res=res|(1 << bitc);}
_0x7E:
	SBIS 0x9,7
	RJMP _0x82
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BREQ _0x83
_0x82:
	RJMP _0x81
_0x83:
	CALL SUBOPT_0x4
; 0000 0074         if (t3_pin && n_ter==3){res=res|(1 << bitc);}
_0x81:
	SBIS 0x3,0
	RJMP _0x85
	LDD  R26,Y+2
	CPI  R26,LOW(0x3)
	BREQ _0x86
_0x85:
	RJMP _0x84
_0x86:
	CALL SUBOPT_0x4
; 0000 0075         if (t4_pin && n_ter==4){res=res|(1 << bitc);}
_0x84:
	SBIS 0x3,1
	RJMP _0x88
	LDD  R26,Y+2
	CPI  R26,LOW(0x4)
	BREQ _0x89
_0x88:
	RJMP _0x87
_0x89:
	CALL SUBOPT_0x4
; 0000 0076         delay_us(45); // ждем до завершения тайм слота
_0x87:
	__DELAY_USB 120
; 0000 0077         };
	SUBI R17,-1
	RJMP _0x64
_0x65:
; 0000 0078         delay_us(5);
	__DELAY_USB 13
; 0000 0079     #asm("sei")
	sei
; 0000 007A     return res;
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060001
; 0000 007B }
; .FEND
;void send_start_measurement(void)
; 0000 007D {
_send_start_measurement:
; .FSTART _send_start_measurement
; 0000 007E 
; 0000 007F     if (w1_find()==4)
	RCALL _w1_find
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8A
; 0000 0080     {
; 0000 0081        w1_send(0xcc);  // пропустить ром
	LDI  R26,LOW(204)
	RCALL _w1_send
; 0000 0082        w1_send(0x44);
	LDI  R26,LOW(68)
	RCALL _w1_send
; 0000 0083     }
; 0000 0084 
; 0000 0085 
; 0000 0086 }
_0x8A:
	RET
; .FEND
;void ds1820_init(void)
; 0000 0088 {
_ds1820_init:
; .FSTART _ds1820_init
; 0000 0089     w1_find();
	CALL SUBOPT_0x5
; 0000 008A     w1_send(0xcc);  // пропустить ром
; 0000 008B     w1_send(0x4e); // команда записи в датчик
	LDI  R26,LOW(78)
	RCALL _w1_send
; 0000 008C     w1_send(0x32); // верхняя граница термостата th
	LDI  R26,LOW(50)
	RCALL _w1_send
; 0000 008D     w1_send(0); // нижняя граница термостата tlow
	LDI  R26,LOW(0)
	RCALL _w1_send
; 0000 008E     w1_send(0x1f); // режим работы - 9 бит
	LDI  R26,LOW(31)
	RCALL _w1_send
; 0000 008F }
	RET
; .FEND
;void read_temp(void)
; 0000 0091 {
_read_temp:
; .FSTART _read_temp
; 0000 0092     unsigned char data[2];
; 0000 0093     int temp = 0;
; 0000 0094     w1_find();//снова посылаем Presence и Reset
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+2
;	temp -> R16,R17
	__GETWRN 16,17,0
	CALL SUBOPT_0x5
; 0000 0095     w1_send(0xcc);
; 0000 0096     w1_send(0xbe);//передать байты ведущему(у 18b20 в первых двух содержится температура)
	LDI  R26,LOW(190)
	RCALL _w1_send
; 0000 0097     data[0] = w1_readbyte(1);
	LDI  R26,LOW(1)
	RCALL _w1_readbyte
	STD  Y+2,R30
; 0000 0098     data[1] = w1_readbyte(1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
; 0000 0099     temp = data[1];
; 0000 009A     temp = temp<<8;
; 0000 009B     temp |= data[0];
; 0000 009C     temp1=temp* 0.0625;
	LDI  R26,LOW(_temp1)
	LDI  R27,HIGH(_temp1)
	CALL SUBOPT_0x7
; 0000 009D      w1_find();//снова посылаем Presence и Reset
; 0000 009E     w1_send(0xcc);
; 0000 009F     w1_send(0xbe);
	LDI  R26,LOW(190)
	RCALL _w1_send
; 0000 00A0     data[0] = w1_readbyte(2);
	LDI  R26,LOW(2)
	RCALL _w1_readbyte
	STD  Y+2,R30
; 0000 00A1     data[1] = w1_readbyte(2);
	LDI  R26,LOW(2)
	CALL SUBOPT_0x6
; 0000 00A2     temp = data[1];
; 0000 00A3     temp = temp<<8;
; 0000 00A4     temp |= data[0];
; 0000 00A5     temp2=temp* 0.0625;
	LDI  R26,LOW(_temp2)
	LDI  R27,HIGH(_temp2)
	CALL SUBOPT_0x7
; 0000 00A6      w1_find();//снова посылаем Presence и Reset
; 0000 00A7     w1_send(0xcc);
; 0000 00A8     w1_send(0xbe);
	LDI  R26,LOW(190)
	RCALL _w1_send
; 0000 00A9     data[0] = w1_readbyte(3);
	LDI  R26,LOW(3)
	RCALL _w1_readbyte
	STD  Y+2,R30
; 0000 00AA     data[1] = w1_readbyte(3);
	LDI  R26,LOW(3)
	CALL SUBOPT_0x6
; 0000 00AB     temp = data[1];
; 0000 00AC     temp = temp<<8;
; 0000 00AD     temp |= data[0];
; 0000 00AE     temp3=temp* 0.0625;
	LDI  R26,LOW(_temp3)
	LDI  R27,HIGH(_temp3)
	CALL SUBOPT_0x7
; 0000 00AF      w1_find();//снова посылаем Presence и Reset
; 0000 00B0     w1_send(0xcc);
; 0000 00B1     w1_send(0xbe);
	LDI  R26,LOW(190)
	RCALL _w1_send
; 0000 00B2     data[0] = w1_readbyte(4);
	LDI  R26,LOW(4)
	RCALL _w1_readbyte
	STD  Y+2,R30
; 0000 00B3     data[1] = w1_readbyte(4);
	LDI  R26,LOW(4)
	CALL SUBOPT_0x6
; 0000 00B4     temp = data[1];
; 0000 00B5     temp = temp<<8;
; 0000 00B6     temp |= data[0];
; 0000 00B7     temp4=temp* 0.0625;
	LDI  R26,LOW(_temp4)
	LDI  R27,HIGH(_temp4)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 00B8     printf("temp1=%i  ",temp1);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp1
	LDS  R31,_temp1+1
	CALL SUBOPT_0x8
; 0000 00B9     printf("temp2=%i  ",temp2);
	__POINTW1FN _0x0,11
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp2
	LDS  R31,_temp2+1
	CALL SUBOPT_0x8
; 0000 00BA     printf("temp3=%i  ",temp3);
	__POINTW1FN _0x0,22
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp3
	LDS  R31,_temp3+1
	CALL SUBOPT_0x8
; 0000 00BB     printf("temp4=%i \n\r",temp4);
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_temp4
	LDS  R31,_temp4+1
	CALL SUBOPT_0x8
; 0000 00BC     pid_frag=1;
	SBI  0x1E,0
; 0000 00BD 
; 0000 00BE }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;interrupt [PC_INT0] void pin_change_isr0(void)
; 0000 00C0 {
_pin_change_isr0:
; .FSTART _pin_change_isr0
	ST   -Y,R30
; 0000 00C1     if (zero_1==1) delay_pow1=0;
	SBIS 0x3,5
	RJMP _0x8D
	LDI  R30,LOW(0)
	STS  _delay_pow1,R30
; 0000 00C2     if (zero_2==1) delay_pow2=0;
_0x8D:
	SBIS 0x3,4
	RJMP _0x8E
	LDI  R30,LOW(0)
	STS  _delay_pow2,R30
; 0000 00C3     if (zero_3==1) delay_pow3=0;
_0x8E:
	SBIS 0x3,3
	RJMP _0x8F
	LDI  R30,LOW(0)
	STS  _delay_pow3,R30
; 0000 00C4 }
_0x8F:
	LD   R30,Y+
	RETI
; .FEND
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00C7 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R15
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C8     bit p1=0,p2=0,p3=0;
; 0000 00C9     TCNT0=0x9C;
;	p1 -> R15.0
;	p2 -> R15.1
;	p3 -> R15.2
	CLR  R15
	LDI  R30,LOW(156)
	OUT  0x26,R30
; 0000 00CA     if ( delay_pow1<100 ) delay_pow1++;
	LDS  R26,_delay_pow1
	CPI  R26,LOW(0x64)
	BRSH _0x90
	LDS  R30,_delay_pow1
	SUBI R30,-LOW(1)
	STS  _delay_pow1,R30
; 0000 00CB     if ( delay_pow2<100 ) delay_pow2++;
_0x90:
	LDS  R26,_delay_pow2
	CPI  R26,LOW(0x64)
	BRSH _0x91
	LDS  R30,_delay_pow2
	SUBI R30,-LOW(1)
	STS  _delay_pow2,R30
; 0000 00CC     if ( delay_pow3<100 ) delay_pow3++;
_0x91:
	LDS  R26,_delay_pow3
	CPI  R26,LOW(0x64)
	BRSH _0x92
	LDS  R30,_delay_pow3
	SUBI R30,-LOW(1)
	STS  _delay_pow3,R30
; 0000 00CD     if (delay_pow1==pow1) p1=1;
_0x92:
	LDS  R30,_pow1
	LDS  R26,_delay_pow1
	CP   R30,R26
	BRNE _0x93
	SET
	BLD  R15,0
; 0000 00CE     if (delay_pow2==pow2) p2=1;
_0x93:
	LDS  R30,_pow2
	LDS  R26,_delay_pow2
	CP   R30,R26
	BRNE _0x94
	SET
	BLD  R15,1
; 0000 00CF     if (delay_pow3==pow3) p3=1;
_0x94:
	LDS  R30,_pow3
	LDS  R26,_delay_pow3
	CP   R30,R26
	BRNE _0x95
	SET
	BLD  R15,2
; 0000 00D0     sem_1=p1;sem_2=p2;sem_3=p3;
_0x95:
	SBRC R15,0
	RJMP _0x96
	CBI  0x8,2
	RJMP _0x97
_0x96:
	SBI  0x8,2
_0x97:
	SBRC R15,1
	RJMP _0x98
	CBI  0x8,1
	RJMP _0x99
_0x98:
	SBI  0x8,1
_0x99:
	SBRC R15,2
	RJMP _0x9A
	CBI  0x8,0
	RJMP _0x9B
_0x9A:
	SBI  0x8,0
_0x9B:
; 0000 00D1 
; 0000 00D2 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	LD   R15,Y+
	RETI
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00D6 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D7 // Reinitialize Timer1 value
; 0000 00D8 TCNT1H=0xBDC >> 8;
	CALL SUBOPT_0x9
; 0000 00D9 TCNT1L=0xBDC & 0xff;
; 0000 00DA 
; 0000 00DB     read_temp();
	RCALL _read_temp
; 0000 00DC     send_start_measurement();
	RCALL _send_start_measurement
; 0000 00DD 
; 0000 00DE 
; 0000 00DF 
; 0000 00E0 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00E3 {
_main:
; .FSTART _main
; 0000 00E4 // Declare your local variables here
; 0000 00E5 int referenceValue, measurementValue, inputValue;
; 0000 00E6 
; 0000 00E7 // Crystal Oscillator division factor: 1
; 0000 00E8 #pragma optsize-
; 0000 00E9 CLKPR=(1<<CLKPCE);
;	referenceValue -> R16,R17
;	measurementValue -> R18,R19
;	inputValue -> R20,R21
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00EA CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00EB #ifdef _OPTIMIZE_SIZE_
; 0000 00EC #pragma optsize+
; 0000 00ED #endif
; 0000 00EE 
; 0000 00EF // Input/Output Ports initialization
; 0000 00F0 // Port B initialization
; 0000 00F1 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00F2 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x4,R30
; 0000 00F3 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00F4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x5,R30
; 0000 00F5 
; 0000 00F6 // Port C initialization
; 0000 00F7 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00F8 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x7,R30
; 0000 00F9 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 00FA PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 00FB 
; 0000 00FC // Port D initialization
; 0000 00FD // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00FE DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0xA,R30
; 0000 00FF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0100 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0xB,R30
; 0000 0101 
; 0000 0102 // Timer/Counter 0 initialization
; 0000 0103 // Clock source: System Clock
; 0000 0104 // Clock value: 1000,000 kHz
; 0000 0105 // Mode: Normal top=0xFF
; 0000 0106 // OC0A output: Disconnected
; 0000 0107 // OC0B output: Disconnected
; 0000 0108 // Timer Period: 0,1 ms
; 0000 0109 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 010A TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 010B TCNT0=0x9C;
	LDI  R30,LOW(156)
	OUT  0x26,R30
; 0000 010C OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 010D OCR0B=0x00;
	OUT  0x28,R30
; 0000 010E 
; 0000 010F // Timer/Counter 1 initialization
; 0000 0110 // Clock source: System Clock
; 0000 0111 // Clock value: 125,000 kHz
; 0000 0112 // Mode: Normal top=0xFFFF
; 0000 0113 // OC1A output: Disconnected
; 0000 0114 // OC1B output: Disconnected
; 0000 0115 // Noise Canceler: Off
; 0000 0116 // Input Capture on Falling Edge
; 0000 0117 // Timer Period: 0,5 s
; 0000 0118 // Timer1 Overflow Interrupt: On
; 0000 0119 // Input Capture Interrupt: Off
; 0000 011A // Compare A Match Interrupt: Off
; 0000 011B // Compare B Match Interrupt: Off
; 0000 011C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 011D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	STS  129,R30
; 0000 011E TCNT1H=0x0B;
	CALL SUBOPT_0x9
; 0000 011F TCNT1L=0xDC;
; 0000 0120 ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0121 ICR1L=0x00;
	STS  134,R30
; 0000 0122 OCR1AH=0x00;
	STS  137,R30
; 0000 0123 OCR1AL=0x00;
	STS  136,R30
; 0000 0124 OCR1BH=0x00;
	STS  139,R30
; 0000 0125 OCR1BL=0x00;
	STS  138,R30
; 0000 0126 
; 0000 0127 // Timer/Counter 2 initialization
; 0000 0128 // Clock source: System Clock
; 0000 0129 // Clock value: Timer2 Stopped
; 0000 012A // Mode: Normal top=0xFF
; 0000 012B // OC2A output: Disconnected
; 0000 012C // OC2B output: Disconnected
; 0000 012D ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 012E TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 012F TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 0130 TCNT2=0x00;
	STS  178,R30
; 0000 0131 OCR2A=0x00;
	STS  179,R30
; 0000 0132 OCR2B=0x00;
	STS  180,R30
; 0000 0133 
; 0000 0134 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0135 TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0136 
; 0000 0137 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0138 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	STS  111,R30
; 0000 0139 
; 0000 013A // Timer/Counter 2 Interrupt(s) initialization
; 0000 013B TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 013C 
; 0000 013D // External Interrupt(s) initialization
; 0000 013E // INT0: Off
; 0000 013F // INT1: Off
; 0000 0140 // Interrupt on any change on pins PCINT0-7: On
; 0000 0141 // Interrupt on any change on pins PCINT8-14: Off
; 0000 0142 // Interrupt on any change on pins PCINT16-23: Off
; 0000 0143 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0144 EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 0145 PCICR=(0<<PCIE2) | (0<<PCIE1) | (1<<PCIE0);
	LDI  R30,LOW(1)
	STS  104,R30
; 0000 0146 PCMSK0=(0<<PCINT7) | (0<<PCINT6) | (1<<PCINT5) | (1<<PCINT4) | (1<<PCINT3) | (0<<PCINT2) | (0<<PCINT1) | (0<<PCINT0);
	LDI  R30,LOW(56)
	STS  107,R30
; 0000 0147 PCIFR=(0<<PCIF2) | (0<<PCIF1) | (1<<PCIF0);
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 0148 
; 0000 0149 // USART initialization
; 0000 014A // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 014B // USART Receiver: Off
; 0000 014C // USART Transmitter: On
; 0000 014D // USART0 Mode: Asynchronous
; 0000 014E // USART Baud Rate: 9600
; 0000 014F UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	LDI  R30,LOW(0)
	STS  192,R30
; 0000 0150 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 0151 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0152 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 0153 UBRR0L=0x33;
	LDI  R30,LOW(51)
	STS  196,R30
; 0000 0154 
; 0000 0155 // Analog Comparator initialization
; 0000 0156 // Analog Comparator: Off
; 0000 0157 // The Analog Comparator's positive input is
; 0000 0158 // connected to the AIN0 pin
; 0000 0159 // The Analog Comparator's negative input is
; 0000 015A // connected to the AIN1 pin
; 0000 015B ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 015C ADCSRB=(0<<ACME);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 015D // Digital input buffer on AIN0: On
; 0000 015E // Digital input buffer on AIN1: On
; 0000 015F DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 0160 
; 0000 0161 // ADC initialization
; 0000 0162 // ADC disabled
; 0000 0163 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	STS  122,R30
; 0000 0164 
; 0000 0165 // SPI initialization
; 0000 0166 // SPI disabled
; 0000 0167 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 0168 
; 0000 0169 // TWI initialization
; 0000 016A // TWI disabled
; 0000 016B TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 016C 
; 0000 016D // 1 Wire Bus initialization
; 0000 016E // 1 Wire Data port: PORTD
; 0000 016F // 1 Wire Data bit: 5
; 0000 0170 // Note: 1 Wire port settings are specified in the
; 0000 0171 // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 0172 
; 0000 0173 ds1820_init();
	RCALL _ds1820_init
; 0000 0174 // Global enable interrupts
; 0000 0175 #asm("sei")
	sei
; 0000 0176 
; 0000 0177 
; 0000 0178 pow1=20;
	LDI  R30,LOW(20)
	STS  _pow1,R30
; 0000 0179 pow2=50;
	LDI  R30,LOW(50)
	STS  _pow2,R30
; 0000 017A pow3=90;
	LDI  R30,LOW(90)
	STS  _pow3,R30
; 0000 017B   Init_pid();
	RCALL _Init_pid
; 0000 017C printf("start \n\r");
	__POINTW1FN _0x0,45
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 017D while (1)
_0x9C:
; 0000 017E       {
; 0000 017F       // Place your code here
; 0000 0180     if(pid_frag)
	SBIS 0x1E,0
	RJMP _0x9F
; 0000 0181     {
; 0000 0182         referenceValue = 40;
	__GETWRN 16,17,40
; 0000 0183         measurementValue = temp1;
	__GETWRMN 18,19,0,_temp1
; 0000 0184 
; 0000 0185         inputValue = pid_Controller(referenceValue, measurementValue, &pidData);
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(_pidData)
	LDI  R27,HIGH(_pidData)
	RCALL _pid_Controller
	MOVW R20,R30
; 0000 0186         if (inputValue>100) inputValue=100;
	__CPWRN 20,21,101
	BRLT _0xA0
	__GETWRN 20,21,100
; 0000 0187         if (inputValue<0) inputValue=0;
_0xA0:
	TST  R21
	BRPL _0xA1
	__GETWRN 20,21,0
; 0000 0188 
; 0000 0189             printf("referenceValue=%i  ",referenceValue);
_0xA1:
	__POINTW1FN _0x0,54
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x8
; 0000 018A             printf("measurementValue=%i  ",measurementValue);
	__POINTW1FN _0x0,74
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CALL SUBOPT_0x8
; 0000 018B             printf("inputValue=%i \n\r",inputValue);
	__POINTW1FN _0x0,96
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CALL SUBOPT_0x8
; 0000 018C         pid_frag=0;
	CBI  0x1E,0
; 0000 018D     }
; 0000 018E       }
_0x9F:
	RJMP _0x9C
; 0000 018F }
_0xA4:
	RJMP _0xA4
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060001:
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x200001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000022
	CPI  R18,37
	BRNE _0x2000023
	LDI  R17,LOW(1)
	RJMP _0x2000024
_0x2000023:
	CALL SUBOPT_0xA
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	CALL SUBOPT_0xA
	RJMP _0x20000D2
_0x2000026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000027
	LDI  R16,LOW(1)
	RJMP _0x2000021
_0x2000027:
	CPI  R18,43
	BRNE _0x2000028
	LDI  R20,LOW(43)
	RJMP _0x2000021
_0x2000028:
	CPI  R18,32
	BRNE _0x2000029
	LDI  R20,LOW(32)
	RJMP _0x2000021
_0x2000029:
	RJMP _0x200002A
_0x2000025:
	CPI  R30,LOW(0x2)
	BRNE _0x200002B
_0x200002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x200002C
	ORI  R16,LOW(128)
	RJMP _0x2000021
_0x200002C:
	RJMP _0x200002D
_0x200002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2000021
_0x200002D:
	CPI  R18,48
	BRLO _0x2000030
	CPI  R18,58
	BRLO _0x2000031
_0x2000030:
	RJMP _0x200002F
_0x2000031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000021
_0x200002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000035
	CALL SUBOPT_0xB
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xC
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x64)
	BREQ _0x200003F
	CPI  R30,LOW(0x69)
	BRNE _0x2000040
_0x200003F:
	ORI  R16,LOW(4)
	RJMP _0x2000041
_0x2000040:
	CPI  R30,LOW(0x75)
	BRNE _0x2000042
_0x2000041:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x58)
	BRNE _0x2000045
	ORI  R16,LOW(8)
	RJMP _0x2000046
_0x2000045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000077
_0x2000046:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000049
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000049:
	CPI  R20,0
	BREQ _0x200004A
	SUBI R17,-LOW(1)
	RJMP _0x200004B
_0x200004A:
	ANDI R16,LOW(251)
_0x200004B:
	RJMP _0x200004C
_0x2000048:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
_0x200004C:
_0x200003C:
	SBRC R16,0
	RJMP _0x200004D
_0x200004E:
	CP   R17,R21
	BRSH _0x2000050
	SBRS R16,7
	RJMP _0x2000051
	SBRS R16,2
	RJMP _0x2000052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000053
_0x2000052:
	LDI  R18,LOW(48)
_0x2000053:
	RJMP _0x2000054
_0x2000051:
	LDI  R18,LOW(32)
_0x2000054:
	CALL SUBOPT_0xA
	SUBI R21,LOW(1)
	RJMP _0x200004E
_0x2000050:
_0x200004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2000055
_0x2000056:
	CPI  R19,0
	BREQ _0x2000058
	SBRS R16,3
	RJMP _0x2000059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x200005B
	SUBI R21,LOW(1)
_0x200005B:
	SUBI R19,LOW(1)
	RJMP _0x2000056
_0x2000058:
	RJMP _0x200005C
_0x2000055:
_0x200005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2000062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000060
_0x2000062:
	CPI  R18,58
	BRLO _0x2000063
	SBRS R16,3
	RJMP _0x2000064
	SUBI R18,-LOW(7)
	RJMP _0x2000065
_0x2000064:
	SUBI R18,-LOW(39)
_0x2000065:
_0x2000063:
	SBRC R16,4
	RJMP _0x2000067
	CPI  R18,49
	BRSH _0x2000069
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x20000D3
_0x2000068:
	CP   R21,R19
	BRLO _0x200006D
	SBRS R16,0
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006F
	LDI  R18,LOW(48)
_0x20000D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x200005F
	RJMP _0x200005E
_0x200005F:
_0x200005C:
	SBRS R16,0
	RJMP _0x2000073
_0x2000074:
	CPI  R21,0
	BREQ _0x2000076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xC
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000036:
_0x20000D2:
	LDI  R17,LOW(0)
_0x2000021:
	RJMP _0x200001C
_0x200001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_delay_pow1:
	.BYTE 0x1
_delay_pow2:
	.BYTE 0x1
_delay_pow3:
	.BYTE 0x1
_pow1:
	.BYTE 0x1
_pow2:
	.BYTE 0x1
_pow3:
	.BYTE 0x1
_temp1:
	.BYTE 0x2
_temp2:
	.BYTE 0x2
_temp3:
	.BYTE 0x2
_temp4:
	.BYTE 0x2
_pidData:
	.BYTE 0x12

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,14
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	__PUTD1S 14
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	__PUTD1SNS 18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	SBI  0xA,6
	SBI  0xA,7
	SBI  0x4,0
	SBI  0x4,1
	CBI  0xB,6
	CBI  0xB,7
	CBI  0x5,0
	CBI  0x5,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL _w1_find
	LDI  R26,LOW(204)
	JMP  _w1_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x6:
	CALL _w1_readbyte
	STD  Y+3,R30
	LDD  R16,Y+3
	CLR  R17
	MOV  R17,R16
	CLR  R16
	LDD  R30,Y+2
	LDI  R31,0
	__ORWRR 16,17,30,31
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3D800000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(11)
	STS  133,R30
	LDI  R30,LOW(220)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
