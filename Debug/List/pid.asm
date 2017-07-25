
;CodeVisionAVR C Compiler V3.10 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x73,0x74,0x61,0x72,0x74,0x20,0xA,0xD
	.DB  0x0,0x65,0x72,0x72,0x3D,0x25,0x69,0x20
	.DB  0x20,0x0,0x74,0x31,0x3D,0x25,0x69,0x20
	.DB  0x20,0x0,0x74,0x32,0x3D,0x25,0x69,0x20
	.DB  0x20,0x0,0x70,0x6F,0x77,0x65,0x72,0x5F
	.DB  0x74,0x6F,0x5F,0x74,0x65,0x6E,0x3D,0x25
	.DB  0x69,0x20,0xA,0xD,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
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
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#define zero_1 PINB.5 // датчик нуля 1-го тену
;#define zero_2 PINB.4 // датчик нуля 2-го тену
;#define zero_3 PINB.3 // датчик нуля 3-го тену
;
;#define sem_1 PORTC.2 // керування 1-им семістором
;#define sem_2 PORTC.1 // керування 2-им семістором
;#define sem_3 PORTC.0 // керування 3-им семістором
;
;
;#define mode_0 PIND.2 //перемикач режимів (OFF)
;#define mode_1 PIND.4 //перемикач режимів (1)
;#define mode_2 PIND.3 //перемикач режимів (2)
;#define mode_3 PIND.5 //перемикач режимів (3)
;
;#define t1_port PORTD.6 // Термодатчик 1
;#define t1_pin PIND.6  // Термодатчик 1
;#define t1_ddr DDRD.6  // Термодатчик 1
;#define t2_port PORTD.7  // Термодатчик 2
;#define t2_pin PIND.7 // Термодатчик 2
;#define t2_ddr DDRD.7 // Термодатчик 2
;#define error_led PORTB.0  // індикатор помилки
;
;
;#define fan PORTB.2 // Вентилятор
;
;
;
;#define maxtemp1  800 // Максимальна температура тену (одиниця на 0.0625 градуса)
;
;
;#define tempmode1  288 // Температура 1-го режиму (одиниця на 0.0625 градуса)
;#define tempmode2  352 // Температура 2-го режиму (одиниця на 0.0625 градуса)
;#define tempmode3  384 // Температура 3-го режиму (одиниця на 0.0625 градуса)
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;
;// Declare your global variables here
;
;
;volatile char delay_pow1=0,delay_pow2=0,delay_pow3=0;
;volatile char pow1=0,pow2=0,pow3=0;
;volatile int temp1,temp2;
;volatile unsigned char res1=0,res2=0;
;volatile int error_cnt=0;
;volatile int mode_temp=0;
;volatile int mode_sem=0;
;volatile int power_to_ten=0;
;
;bit pid_frag=0;
;
;
;int w1_find(void) // Перевірка наявності та скидання пристрою на 1-wire для всіх 4 термодатчиків
; 0000 0038 {

	.CSEG
_w1_find:
; .FSTART _w1_find
; 0000 0039     int device=0;
; 0000 003A     t1_ddr=1; t2_ddr=1;
	RCALL __SAVELOCR2
;	device -> R16,R17
	__GETWRN 16,17,0
	RCALL SUBOPT_0x0
; 0000 003B     t1_port=0; t2_port=0;
; 0000 003C     delay_us(485);
	__DELAY_USW 970
; 0000 003D     t1_ddr=0; t2_ddr=0;
	CBI  0x11,6
	CBI  0x11,7
; 0000 003E     delay_us(65);
	__DELAY_USB 173
; 0000 003F     device=device+!t1_port;
	LDI  R30,0
	SBIS 0x12,6
	LDI  R30,1
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 0040     device=device+!t2_port;
	LDI  R30,0
	SBIS 0x12,7
	LDI  R30,1
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 0041     delay_us(420);
	__DELAY_USW 840
; 0000 0042     return device;
	MOVW R30,R16
	RJMP _0x2060003
; 0000 0043 }
; .FEND
;
;void w1_send(char cmd) // відправка  байту 1-wire для всіх 4 термодатчиків
; 0000 0046 {
_w1_send:
; .FSTART _w1_send
; 0000 0047     unsigned char bitc=0;
; 0000 0048     for (bitc=0; bitc < 8; bitc++)
	ST   -Y,R26
	ST   -Y,R17
;	cmd -> Y+1
;	bitc -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x10:
	CPI  R17,8
	BRSH _0x11
; 0000 0049      {
; 0000 004A         if (cmd&0x01) // сравниваем младший бит
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	BREQ _0x12
; 0000 004B         {
; 0000 004C             t1_ddr=1; t2_ddr=1;
	RCALL SUBOPT_0x0
; 0000 004D             t1_port=0; t2_port=0;
; 0000 004E             delay_us(15);
	__DELAY_USB 40
; 0000 004F             t1_port=1;t2_port=1;
	SBI  0x12,6
	SBI  0x12,7
; 0000 0050             delay_us(50);
	__DELAY_USB 133
; 0000 0051             t1_ddr=0;t2_ddr=0;
	RJMP _0x7B
; 0000 0052             delay_us(5);
; 0000 0053         }
; 0000 0054         else
_0x12:
; 0000 0055         {
; 0000 0056             t1_ddr=1; t2_ddr=1;
	RCALL SUBOPT_0x0
; 0000 0057             t1_port=0; t2_port=0;
; 0000 0058             delay_us(65);
	__DELAY_USB 173
; 0000 0059             t1_ddr=0; t2_ddr=0;
_0x7B:
	CBI  0x11,6
	CBI  0x11,7
; 0000 005A             delay_us(5);
	__DELAY_USB 13
; 0000 005B         };
; 0000 005C         cmd=cmd>>1;
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
; 0000 005D         };
	SUBI R17,-1
	RJMP _0x10
_0x11:
; 0000 005E }
	LDD  R17,Y+0
	RJMP _0x2060001
; .FEND
;
;
;char w1_readbyte() // Читання  байту 1-wire для всіх 4 термодатчиків
; 0000 0062 {
_w1_readbyte:
; .FSTART _w1_readbyte
; 0000 0063     unsigned char bitc=0;
; 0000 0064     unsigned char res=0;
; 0000 0065     res1=0;res2=0;
	RCALL __SAVELOCR2
;	bitc -> R17
;	res -> R16
	LDI  R17,0
	LDI  R16,0
	LDI  R30,LOW(0)
	STS  _res1,R30
	STS  _res2,R30
; 0000 0066     for (bitc=0; bitc < 8; bitc++)
	LDI  R17,LOW(0)
_0x31:
	CPI  R17,8
	BRSH _0x32
; 0000 0067         {
; 0000 0068         t1_ddr=1; t2_ddr=1;
	RCALL SUBOPT_0x0
; 0000 0069         t1_port=0; t2_port=0;
; 0000 006A         delay_us(1);
	__DELAY_USB 3
; 0000 006B         t1_ddr=0;t2_ddr=0;
	CBI  0x11,6
	CBI  0x11,7
; 0000 006C         delay_us(14);
	__DELAY_USB 37
; 0000 006D         if (t1_pin){res1=res1|(1 << bitc);}
	SBIS 0x10,6
	RJMP _0x3F
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDS  R26,_res1
	OR   R30,R26
	STS  _res1,R30
; 0000 006E         if (t2_pin){res2=res2|(1 << bitc);}
_0x3F:
	SBIS 0x10,7
	RJMP _0x40
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDS  R26,_res2
	OR   R30,R26
	STS  _res2,R30
; 0000 006F         delay_us(45);
_0x40:
	__DELAY_USB 120
; 0000 0070         };
	SUBI R17,-1
	RJMP _0x31
_0x32:
; 0000 0071         delay_us(5);
	__DELAY_USB 13
; 0000 0072     return res;
	MOV  R30,R16
_0x2060003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0073 }
; .FEND
;void send_start_measurement(void) // Відправка команди початку вимірювання температури для всіх 4 термодатчиків
; 0000 0075 {
_send_start_measurement:
; .FSTART _send_start_measurement
; 0000 0076     w1_find();
	RCALL SUBOPT_0x1
; 0000 0077     w1_send(0xcc);  // пропустить ром
; 0000 0078     w1_send(0x44);
	LDI  R26,LOW(68)
	RJMP _0x2060002
; 0000 0079 }
; .FEND
;void ds1820_init(void) // ініціалізація всіх 4 термодатчиків
; 0000 007B {
_ds1820_init:
; .FSTART _ds1820_init
; 0000 007C     w1_find();
	RCALL SUBOPT_0x1
; 0000 007D     w1_send(0xcc);  // пропустить ром
; 0000 007E     w1_send(0x4e); // команда записи в датчик
	LDI  R26,LOW(78)
	RCALL _w1_send
; 0000 007F     w1_send(0x32); // верхняя граница термостата th
	LDI  R26,LOW(50)
	RCALL _w1_send
; 0000 0080     w1_send(0); // нижняя граница термостата tlow
	LDI  R26,LOW(0)
	RCALL _w1_send
; 0000 0081     w1_send(0x1f); // режим работы - 9 бит
	LDI  R26,LOW(31)
_0x2060002:
	RCALL _w1_send
; 0000 0082 }
	RET
; .FEND
;void read_temp(void) // Читання температури всіх 4 термодатчиків
; 0000 0084 {
_read_temp:
; .FSTART _read_temp
; 0000 0085     unsigned char data[2];
; 0000 0086     w1_find();
	SBIW R28,2
;	data -> Y+0
	RCALL SUBOPT_0x1
; 0000 0087     w1_send(0xcc);
; 0000 0088     w1_send(0xbe);
	LDI  R26,LOW(190)
	RCALL _w1_send
; 0000 0089     w1_readbyte();
	RCALL _w1_readbyte
; 0000 008A     data[0] = res1; data[1] = res2;
	LDS  R30,_res1
	ST   Y,R30
	LDS  R30,_res2
	STD  Y+1,R30
; 0000 008B     w1_readbyte();
	RCALL _w1_readbyte
; 0000 008C     temp1 = (res1<<8)| data[0];
	LDS  R27,_res1
	LDI  R26,LOW(0)
	LD   R30,Y
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _temp1,R30
	STS  _temp1+1,R31
; 0000 008D     temp2 = (res2<<8)| data[1];
	LDS  R27,_res2
	LDI  R26,LOW(0)
	LDD  R30,Y+1
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _temp2,R30
	STS  _temp2+1,R31
; 0000 008E }
	RJMP _0x2060001
; .FEND
;void check_mode(void) // Перевірка стану перемикача режимів (Виставлення необхідної температури в кімнаті)
; 0000 0090 {
_check_mode:
; .FSTART _check_mode
; 0000 0091     mode_temp=-50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	RCALL SUBOPT_0x2
; 0000 0092     if (mode_1==0) mode_temp=tempmode1;
	SBIC 0x10,4
	RJMP _0x41
	LDI  R30,LOW(288)
	LDI  R31,HIGH(288)
	RCALL SUBOPT_0x2
; 0000 0093     if (mode_2==0) mode_temp=tempmode2;
_0x41:
	SBIC 0x10,3
	RJMP _0x42
	LDI  R30,LOW(352)
	LDI  R31,HIGH(352)
	RCALL SUBOPT_0x2
; 0000 0094     if (mode_3==0) mode_temp=tempmode3;
_0x42:
	SBIC 0x10,5
	RJMP _0x43
	LDI  R30,LOW(384)
	LDI  R31,HIGH(384)
	RCALL SUBOPT_0x2
; 0000 0095 }
_0x43:
	RET
; .FEND
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) // Переривання таймера кожні 0.1мс (задавання інтервалів вмикання семісто ...
; 0000 0099 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R15
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 009A     bit p1=0,p2=0,p3=0;
; 0000 009B     TCNT0=0x9C;
;	p1 -> R15.0
;	p2 -> R15.1
;	p3 -> R15.2
	CLR  R15
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 009C     if (zero_1==1) delay_pow1=0;
	SBIS 0x16,5
	RJMP _0x44
	LDI  R30,LOW(0)
	STS  _delay_pow1,R30
; 0000 009D     if (zero_2==1) delay_pow2=0;
_0x44:
	SBIS 0x16,4
	RJMP _0x45
	LDI  R30,LOW(0)
	STS  _delay_pow2,R30
; 0000 009E     if (zero_3==1) delay_pow3=0;
_0x45:
	SBIS 0x16,3
	RJMP _0x46
	LDI  R30,LOW(0)
	STS  _delay_pow3,R30
; 0000 009F     if ( delay_pow1<105 ) delay_pow1++;
_0x46:
	LDS  R26,_delay_pow1
	CPI  R26,LOW(0x69)
	BRSH _0x47
	LDS  R30,_delay_pow1
	SUBI R30,-LOW(1)
	STS  _delay_pow1,R30
; 0000 00A0     if ( delay_pow2<105 ) delay_pow2++;
_0x47:
	LDS  R26,_delay_pow2
	CPI  R26,LOW(0x69)
	BRSH _0x48
	LDS  R30,_delay_pow2
	SUBI R30,-LOW(1)
	STS  _delay_pow2,R30
; 0000 00A1     if ( delay_pow3<105 ) delay_pow3++;
_0x48:
	LDS  R26,_delay_pow3
	CPI  R26,LOW(0x69)
	BRSH _0x49
	LDS  R30,_delay_pow3
	SUBI R30,-LOW(1)
	STS  _delay_pow3,R30
; 0000 00A2     if (delay_pow1==pow1) p1=1;
_0x49:
	LDS  R30,_pow1
	LDS  R26,_delay_pow1
	CP   R30,R26
	BRNE _0x4A
	SET
	BLD  R15,0
; 0000 00A3     if (delay_pow2==pow2) p2=1;
_0x4A:
	LDS  R30,_pow2
	LDS  R26,_delay_pow2
	CP   R30,R26
	BRNE _0x4B
	SET
	BLD  R15,1
; 0000 00A4     if (delay_pow3==pow3) p3=1;
_0x4B:
	LDS  R30,_pow3
	LDS  R26,_delay_pow3
	CP   R30,R26
	BRNE _0x4C
	SET
	BLD  R15,2
; 0000 00A5     sem_1=p1;sem_2=p2;sem_3=p3;
_0x4C:
	SBRC R15,0
	RJMP _0x4D
	CBI  0x15,2
	RJMP _0x4E
_0x4D:
	SBI  0x15,2
_0x4E:
	SBRC R15,1
	RJMP _0x4F
	CBI  0x15,1
	RJMP _0x50
_0x4F:
	SBI  0x15,1
_0x50:
	SBRC R15,2
	RJMP _0x51
	CBI  0x15,0
	RJMP _0x52
_0x51:
	SBI  0x15,0
_0x52:
; 0000 00A6 
; 0000 00A7 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	LD   R15,Y+
	RETI
; .FEND
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void) // Переривання таймера кожні 100мс (вимір температури, перевірка стану пе ...
; 0000 00AA {
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
; 0000 00AB // Reinitialize Timer1 value
; 0000 00AC TCNT1H=0;
	RCALL SUBOPT_0x3
; 0000 00AD TCNT1L=0;
; 0000 00AE      #asm("cli")
	cli
; 0000 00AF     read_temp();
	RCALL _read_temp
; 0000 00B0     send_start_measurement();
	RCALL _send_start_measurement
; 0000 00B1     check_mode();
	RCALL _check_mode
; 0000 00B2     pid_frag=1;
	SET
	BLD  R2,0
; 0000 00B3     delay_pow1=0;
	LDI  R30,LOW(0)
	STS  _delay_pow1,R30
; 0000 00B4     delay_pow2=0;
	STS  _delay_pow2,R30
; 0000 00B5     delay_pow3=0;
	STS  _delay_pow3,R30
; 0000 00B6      #asm("sei")
	sei
; 0000 00B7 }
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
;void set_power_ten1(int power) // Встановлення вихідної потужності для тена 1
; 0000 00B9 {
_set_power_ten1:
; .FSTART _set_power_ten1
; 0000 00BA     if (power>99) power=99;
	RCALL SUBOPT_0x4
;	power -> Y+0
	BRLT _0x53
	RCALL SUBOPT_0x5
; 0000 00BB     if (power>5) { pow1=100-power;} else {pow1=110;}
_0x53:
	RCALL SUBOPT_0x6
	BRLT _0x54
	RCALL SUBOPT_0x7
	RJMP _0x7C
_0x54:
	LDI  R30,LOW(110)
_0x7C:
	STS  _pow1,R30
; 0000 00BC }
	RJMP _0x2060001
; .FEND
;void set_power_ten2(int power) // Встановлення вихідної потужності для тена 2
; 0000 00BE {
_set_power_ten2:
; .FSTART _set_power_ten2
; 0000 00BF     if (power>99) power=99;
	RCALL SUBOPT_0x4
;	power -> Y+0
	BRLT _0x56
	RCALL SUBOPT_0x5
; 0000 00C0     if (power>5) { pow2=100-power;} else {pow2=110;}
_0x56:
	RCALL SUBOPT_0x6
	BRLT _0x57
	RCALL SUBOPT_0x7
	RJMP _0x7D
_0x57:
	LDI  R30,LOW(110)
_0x7D:
	STS  _pow2,R30
; 0000 00C1 }
	RJMP _0x2060001
; .FEND
;void set_power_ten3(int power) // Встановлення вихідної потужності для тена 3
; 0000 00C3 {
_set_power_ten3:
; .FSTART _set_power_ten3
; 0000 00C4     if (power>99) power=99;
	RCALL SUBOPT_0x4
;	power -> Y+0
	BRLT _0x59
	RCALL SUBOPT_0x5
; 0000 00C5     if (power>5) { pow3=100-power;} else {pow3=110;}
_0x59:
	RCALL SUBOPT_0x6
	BRLT _0x5A
	RCALL SUBOPT_0x7
	RJMP _0x7E
_0x5A:
	LDI  R30,LOW(110)
_0x7E:
	STS  _pow3,R30
; 0000 00C6 }
_0x2060001:
	ADIW R28,2
	RET
; .FEND
;
;
;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00CC {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
; 0000 00CD // Reinitialize Timer2 value
; 0000 00CE TCNT2=0x06;
	LDI  R30,LOW(6)
	OUT  0x24,R30
; 0000 00CF // Place your code here
; 0000 00D0 
; 0000 00D1 
; 0000 00D2 }
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00D5 {
_main:
; .FSTART _main
; 0000 00D6 // Declare your local variables here
; 0000 00D7 
; 0000 00D8 int tt1=0,tt2=0;
; 0000 00D9 // Input/Output Ports initialization
; 0000 00DA // Port B initialization
; 0000 00DB // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=out
; 0000 00DC DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
;	tt1 -> R16,R17
;	tt2 -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDI  R30,LOW(1)
	OUT  0x17,R30
; 0000 00DD // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00DE PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00DF 
; 0000 00E0 // Port C initialization
; 0000 00E1 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00E2 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 00E3 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 00E4 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00E5 
; 0000 00E6 // Port D initialization
; 0000 00E7 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00E8 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00E9 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00EA PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00EB 
; 0000 00EC // Timer/Counter 0 initialization
; 0000 00ED // Clock source: System Clock
; 0000 00EE // Clock value: 1000,000 kHz
; 0000 00EF TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00F0 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00F1 
; 0000 00F2 // Timer/Counter 1 initialization
; 0000 00F3 // Clock source: System Clock
; 0000 00F4 // Clock value: 125,000 kHz
; 0000 00F5 // Mode: Normal top=0xFFFF
; 0000 00F6 // OC1A output: Disconnected
; 0000 00F7 // OC1B output: Disconnected
; 0000 00F8 // Noise Canceler: Off
; 0000 00F9 // Input Capture on Falling Edge
; 0000 00FA // Timer Period: 0,52429 s
; 0000 00FB // Timer1 Overflow Interrupt: On
; 0000 00FC // Input Capture Interrupt: Off
; 0000 00FD // Compare A Match Interrupt: Off
; 0000 00FE // Compare B Match Interrupt: Off
; 0000 00FF TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0100 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0101 TCNT1H=0x00;
	RCALL SUBOPT_0x3
; 0000 0102 TCNT1L=0x00;
; 0000 0103 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0104 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0105 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0106 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0107 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0108 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0109 
; 0000 010A // Timer/Counter 2 initialization
; 0000 010B // Clock source: System Clock
; 0000 010C // Clock value: Timer2 Stopped
; 0000 010D // Mode: Normal top=0xFF
; 0000 010E // OC2 output: Disconnected
; 0000 010F ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0110 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0111 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0112 OCR2=0x00;
	OUT  0x23,R30
; 0000 0113 
; 0000 0114 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0115 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0116 
; 0000 0117 // External Interrupt(s) initialization
; 0000 0118 // INT0: Off
; 0000 0119 // INT1: Off
; 0000 011A MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 011B 
; 0000 011C // USART initialization
; 0000 011D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 011E // USART Receiver: Off
; 0000 011F // USART Transmitter: On
; 0000 0120 // USART Mode: Asynchronous
; 0000 0121 // USART Baud Rate: 9600
; 0000 0122 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0123 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0124 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0125 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0126 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0127 
; 0000 0128 // Analog Comparator initialization
; 0000 0129 // Analog Comparator: Off
; 0000 012A // The Analog Comparator's positive input is
; 0000 012B // connected to the AIN0 pin
; 0000 012C // The Analog Comparator's negative input is
; 0000 012D // connected to the AIN1 pin
; 0000 012E ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 012F SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0130 
; 0000 0131 // ADC initialization
; 0000 0132 // ADC disabled
; 0000 0133 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0134 
; 0000 0135 // SPI initialization
; 0000 0136 // SPI disabled
; 0000 0137 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0138 
; 0000 0139 // TWI initialization
; 0000 013A // TWI disabled
; 0000 013B TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 013C 
; 0000 013D ds1820_init();
	RCALL _ds1820_init
; 0000 013E // Global enable interrupts
; 0000 013F 
; 0000 0140 set_power_ten1(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _set_power_ten1
; 0000 0141 set_power_ten2(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _set_power_ten2
; 0000 0142 set_power_ten3(0);
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _set_power_ten3
; 0000 0143 #asm("sei")
	sei
; 0000 0144 
; 0000 0145 
; 0000 0146 printf("start \n\r");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x8
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 0147 while (1)
_0x5C:
; 0000 0148 {
; 0000 0149       // Place your code here
; 0000 014A     if(pid_frag)
	SBRS R2,0
	RJMP _0x5F
; 0000 014B     {
; 0000 014C         if (mode_temp>temp2 && temp2!=-1)
	RCALL SUBOPT_0x9
	LDS  R26,_mode_temp
	LDS  R27,_mode_temp+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x61
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	BRNE _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 014D         {
; 0000 014E             if(temp1<1200 && temp1!=-1)
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRGE _0x64
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xB
	BRNE _0x65
_0x64:
	RJMP _0x63
_0x65:
; 0000 014F             {
; 0000 0150                if (temp1<maxtemp1)
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x320)
	LDI  R30,HIGH(0x320)
	CPC  R27,R30
	BRGE _0x66
; 0000 0151                {
; 0000 0152                  mode_sem=1; // Режим зростання потужності
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x7F
; 0000 0153                }
; 0000 0154                else
_0x66:
; 0000 0155                {
; 0000 0156                  mode_sem=2; // Режим спадання потужності
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x7F:
	STS  _mode_sem,R30
	STS  _mode_sem+1,R31
; 0000 0157                }
; 0000 0158             }
; 0000 0159             else
	RJMP _0x68
_0x63:
; 0000 015A             {
; 0000 015B                 mode_sem=2; // Режим спадання потужності
	RCALL SUBOPT_0xD
; 0000 015C             }
_0x68:
; 0000 015D         }
; 0000 015E         else
	RJMP _0x69
_0x60:
; 0000 015F         {
; 0000 0160             mode_sem=2; // Режим спадання потужності
	RCALL SUBOPT_0xD
; 0000 0161         }
_0x69:
; 0000 0162 
; 0000 0163         if (mode_sem==1 && power_to_ten<100)
	RCALL SUBOPT_0xE
	SBIW R26,1
	BRNE _0x6B
	RCALL SUBOPT_0xF
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x6C
_0x6B:
	RJMP _0x6A
_0x6C:
; 0000 0164         {
; 0000 0165             power_to_ten++;
	LDI  R26,LOW(_power_to_ten)
	LDI  R27,HIGH(_power_to_ten)
	RCALL SUBOPT_0x10
; 0000 0166         }
; 0000 0167 
; 0000 0168         if (mode_sem==2 && power_to_ten>1)
_0x6A:
	RCALL SUBOPT_0xE
	SBIW R26,2
	BRNE _0x6E
	RCALL SUBOPT_0xF
	SBIW R26,2
	BRGE _0x6F
_0x6E:
	RJMP _0x6D
_0x6F:
; 0000 0169         {
; 0000 016A             power_to_ten=power_to_ten-20;
	RCALL SUBOPT_0x11
	SBIW R30,20
	STS  _power_to_ten,R30
	STS  _power_to_ten+1,R31
; 0000 016B             if (power_to_ten<0) {power_to_ten=0;}
	LDS  R26,_power_to_ten+1
	TST  R26
	BRPL _0x70
	LDI  R30,LOW(0)
	STS  _power_to_ten,R30
	STS  _power_to_ten+1,R30
; 0000 016C         }
_0x70:
; 0000 016D 
; 0000 016E 
; 0000 016F 
; 0000 0170 
; 0000 0171 
; 0000 0172         set_power_ten1(power_to_ten);
_0x6D:
	RCALL SUBOPT_0xF
	RCALL _set_power_ten1
; 0000 0173         set_power_ten2(power_to_ten);
	RCALL SUBOPT_0xF
	RCALL _set_power_ten2
; 0000 0174         set_power_ten3(power_to_ten);
	RCALL SUBOPT_0xF
	RCALL _set_power_ten3
; 0000 0175         if(temp1>1200 || temp1==-1) error_cnt++;
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRGE _0x72
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xB
	BRNE _0x71
_0x72:
	LDI  R26,LOW(_error_cnt)
	LDI  R27,HIGH(_error_cnt)
	RCALL SUBOPT_0x10
; 0000 0176         if(temp2>1200 || temp2==-1) error_cnt++;
_0x71:
	RCALL SUBOPT_0xA
	CPI  R26,LOW(0x4B1)
	LDI  R30,HIGH(0x4B1)
	CPC  R27,R30
	BRGE _0x75
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	BRNE _0x74
_0x75:
	LDI  R26,LOW(_error_cnt)
	LDI  R27,HIGH(_error_cnt)
	RCALL SUBOPT_0x10
; 0000 0177         if (error_cnt>100) error_led=1;
_0x74:
	LDS  R26,_error_cnt
	LDS  R27,_error_cnt+1
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x77
	SBI  0x18,0
; 0000 0178         printf("err=%i  ", error_cnt);
_0x77:
	__POINTW1FN _0x0,9
	RCALL SUBOPT_0x8
	LDS  R30,_error_cnt
	LDS  R31,_error_cnt+1
	RCALL SUBOPT_0x12
; 0000 0179         tt1=temp1*0.0625;
	LDS  R30,_temp1
	LDS  R31,_temp1+1
	RCALL SUBOPT_0x13
	MOVW R16,R30
; 0000 017A         tt2=temp2*0.0625;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
	MOVW R18,R30
; 0000 017B         printf("t1=%i  ",tt1);
	__POINTW1FN _0x0,18
	RCALL SUBOPT_0x8
	MOVW R30,R16
	RCALL SUBOPT_0x12
; 0000 017C         printf("t2=%i  ",tt2);
	__POINTW1FN _0x0,26
	RCALL SUBOPT_0x8
	MOVW R30,R18
	RCALL SUBOPT_0x12
; 0000 017D         printf("power_to_ten=%i \n\r",power_to_ten);
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 017E         pid_frag=0;
	CLT
	BLD  R2,0
; 0000 017F 
; 0000 0180     }
; 0000 0181 
; 0000 0182 }
_0x5F:
	RJMP _0x5C
; 0000 0183 }
_0x7A:
	RJMP _0x7A
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	RCALL SUBOPT_0x14
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x10
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x14
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
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
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x15
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x15
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x16
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x18
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x1B
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x1B
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1C
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1C
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x15
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x1B
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x1B
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x18
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x18
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x8
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x8
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x14
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
	RCALL SUBOPT_0x14
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
_res1:
	.BYTE 0x1
_res2:
	.BYTE 0x1
_error_cnt:
	.BYTE 0x2
_mode_temp:
	.BYTE 0x2
_mode_sem:
	.BYTE 0x2
_power_to_ten:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	SBI  0x11,6
	SBI  0x11,7
	CBI  0x12,6
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	RCALL _w1_find
	LDI  R26,LOW(204)
	RJMP _w1_send

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	STS  _mode_temp,R30
	STS  _mode_temp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LD   R26,Y
	LDI  R30,LOW(100)
	SUB  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R30,_temp2
	LDS  R31,_temp2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDS  R26,_temp2
	LDS  R27,_temp2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	LDS  R26,_temp1
	LDS  R27,_temp1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _mode_sem,R30
	STS  _mode_sem+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDS  R26,_mode_sem
	LDS  R27,_mode_sem+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xF:
	LDS  R26,_power_to_ten
	LDS  R27,_power_to_ten+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x10:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDS  R30,_power_to_ten
	LDS  R31,_power_to_ten+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3D800000
	RCALL __MULF12
	RCALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x15:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x16
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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
