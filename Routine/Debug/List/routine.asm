
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _PAUSE=R4
	.DEF _PAUSE_msb=R5
	.DEF _ENDLINE=R6
	.DEF _ENDLINE_msb=R7
	.DEF _ONE=R8
	.DEF _ONE_msb=R9
	.DEF _NEXT=R10
	.DEF _NEXT_msb=R11
	.DEF _step1=R12
	.DEF _step1_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rxc
	JMP  _usart0_dre
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x20,0x4E,0x80,0xBB
	.DB  0x70,0x17,0xD0,0x7
	.DB  0x0,0x0

_0x3:
	.DB  0x78,0x5
_0x4:
	.DB  0x78,0x5
_0x0:
	.DB  0x31,0x0,0x35,0x0,0x32,0x0,0x33,0x0
	.DB  0x34,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _sp1
	.DW  _0x3*2

	.DW  0x02
	.DW  _sp2
	.DW  _0x4*2

	.DW  0x02
	.DW  _0x2B
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x2B+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x2B+4
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x2B+6
	.DW  _0x0*2+6

	.DW  0x02
	.DW  _0x2B+8
	.DW  _0x0*2+8

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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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

	OUT  RAMPZ,R24

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
	.ORG 0x500

	.CSEG
;#include <delay.h>
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;
;#define m0_on PORTA&=0xFE
;#define m1_on PORTA&=0xFD
;#define m2_on PORTA&=0xFB
;#define m3_on PORTA&=0xF7
;
;#define m0_off PORTA|=0x01
;#define m1_off PORTA|=0x02
;#define m2_off PORTA|=0x04
;#define m3_off PORTA|=0x08
;
;#define m0_t PORTA^=0x01
;#define m1_t PORTA^=0x02
;#define m2_t PORTA^=0x04
;#define m3_t PORTA^=0x08
;
;#define g1_on TIMSK|=0x10
;#define g2_on TIMSK|=0x08
;
;#define g1_off TIMSK&=0xEF
;#define g2_off TIMSK&=0xF7
;
;#define forward PORTB|=0x10 //PORTB4=1
;#define backward PORTB&=0xEF //PORTB4=0
;
;#define buzzer_on  PORTA|=0x10 //PORTA4=1      0001 0000
;#define buzzer_off  PORTA&=0xEF //PORTA4=0      1110 1111
;#define buzzer_t PORTA^=0x10
;
;unsigned int PAUSE=20000; //디스펜서까지의 거리
;unsigned int ENDLINE=48000; //끝까지의 스텝수 저장 상수
;unsigned int ONE=6000; //한 알  스텝 수 저장 상수
;unsigned int NEXT=2000; //약통의 다음칸으로 이동할 스텝수 저장 상수
;
;unsigned int step1=0; //디스펜서의 현재 스텝 저장 변수
;unsigned int step2=0; //이동모터의 현재 스텝 저장 변수
;
;unsigned char start=0;
;unsigned int where2=0;
;unsigned int target=0;
;unsigned int position=0; //현재 위치
;
;unsigned int txdata=0; //시리얼 통신의 송신데이터 저장 변수
;unsigned char rxdata=0; //시리얼 통신의 수신데이터 저장 변수
;unsigned char pill0[3]={0,0,0}; //[현재 몇 알 줬는지, 한번에 몇 알, 하루에 몇 번] 순으로 저장
;unsigned char pill1[3]={0,0,0};
;unsigned char pill2[3]={0,0,0};
;unsigned char unit[3]={0,0,0}; //[약 종류, 한 번에 몇 알, 하루에 몇 번] 순으로 저장
;unsigned char index=0;
;
;unsigned int sp1=1400;

	.DSEG
;unsigned int sp2=1400;
;
;void init(){
; 0000 0039 void init(){

	.CSEG
_init:
; .FSTART _init
; 0000 003A     unsigned char i;
; 0000 003B     txdata=0;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(0)
	STS  _txdata,R30
	STS  _txdata+1,R30
; 0000 003C     rxdata=0;
	STS  _rxdata,R30
; 0000 003D     step1=0;
	CLR  R12
	CLR  R13
; 0000 003E     step2=0;
	STS  _step2,R30
	STS  _step2+1,R30
; 0000 003F     m0_off;
	SBI  0x1B,0
; 0000 0040     m1_off;
	SBI  0x1B,1
; 0000 0041     m2_off;
	SBI  0x1B,2
; 0000 0042     m3_off;
	SBI  0x1B,3
; 0000 0043     g1_off;
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
; 0000 0044     g2_off;
	IN   R30,0x37
	ANDI R30,0XF7
	OUT  0x37,R30
; 0000 0045     index=0;
	LDI  R30,LOW(0)
	STS  _index,R30
; 0000 0046     for(i=0; i<3; i++)
	LDI  R17,LOW(0)
_0x6:
	CPI  R17,3
	BRSH _0x7
; 0000 0047     {
; 0000 0048         pill0[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_pill0)
	SBCI R31,HIGH(-_pill0)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0049         pill1[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_pill1)
	SBCI R31,HIGH(-_pill1)
	STD  Z+0,R26
; 0000 004A         pill2[i]=0;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_pill2)
	SBCI R31,HIGH(-_pill2)
	STD  Z+0,R26
; 0000 004B     }
	SUBI R17,-1
	RJMP _0x6
_0x7:
; 0000 004C }
	LD   R17,Y+
	RET
; .FEND
;void BTinit(void)
; 0000 004E {
_BTinit:
; .FSTART _BTinit
; 0000 004F     UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0050     UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0051     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0052     UBRR0H=0;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0053     UBRR0L=103;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 0054 }
	RET
; .FEND
;
;void transmit() //after setting txdata
; 0000 0057 {
_transmit:
; .FSTART _transmit
; 0000 0058      UCSR0B |= 0x20;
	SBI  0xA,5
; 0000 0059      delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 005A }
	RET
; .FEND
;void string(char *str)
; 0000 005C {
_string:
; .FSTART _string
; 0000 005D     unsigned int i=0;
; 0000 005E     for(i=0; str[i]; i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x9:
	CALL SUBOPT_0x0
	CPI  R30,0
	BREQ _0xA
; 0000 005F     {
; 0000 0060         txdata=str[i];
	CALL SUBOPT_0x0
	LDI  R31,0
	STS  _txdata,R30
	STS  _txdata+1,R31
; 0000 0061         transmit();
	RCALL _transmit
; 0000 0062         delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0063     }
	__ADDWRN 16,17,1
	RJMP _0x9
_0xA:
; 0000 0064 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;void beep(unsigned int n){
; 0000 0065 void beep(unsigned int n){
_beep:
; .FSTART _beep
; 0000 0066     buzzer_on;
	ST   -Y,R27
	ST   -Y,R26
;	n -> Y+0
	SBI  0x1B,4
; 0000 0067     delay_ms(n);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
; 0000 0068     buzzer_off;
	CBI  0x1B,4
; 0000 0069 }
	RJMP _0x2060002
; .FEND
;void vel_f5()
; 0000 006B {
_vel_f5:
; .FSTART _vel_f5
; 0000 006C     OCR1AH=(sp1>>8);
	LDS  R30,_sp1+1
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
; 0000 006D     OCR1AL=sp1;
	LDS  R30,_sp1
	OUT  0x2A,R30
; 0000 006E     OCR1BH=(sp2>>8);
	LDS  R30,_sp2+1
	ANDI R31,HIGH(0x0)
	OUT  0x29,R30
; 0000 006F     OCR1BL=sp2;
	LDS  R30,_sp2
	OUT  0x28,R30
; 0000 0070 }
	RET
; .FEND
;
;void wait(unsigned int t)
; 0000 0073 {
_wait:
; .FSTART _wait
; 0000 0074     t*=3;
	ST   -Y,R27
	ST   -Y,R26
;	t -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(3)
	CALL __MULB1W2U
	ST   Y,R30
	STD  Y+1,R31
; 0000 0075     t/=4;
	CALL __LSRW2
	ST   Y,R30
	STD  Y+1,R31
; 0000 0076     delay_ms(t);
	LD   R26,Y
	LDD  R27,Y+1
	CALL _delay_ms
; 0000 0077 }
	RJMP _0x2060002
; .FEND
;void motor0()
; 0000 0079 {
_motor0:
; .FSTART _motor0
; 0000 007A     m0_on;
	CBI  0x1B,0
; 0000 007B     g1_on;
	IN   R30,0x37
	ORI  R30,0x10
	RJMP _0x2060003
; 0000 007C }
; .FEND
;void motor1()
; 0000 007E {
_motor1:
; .FSTART _motor1
; 0000 007F     m1_on;
	CBI  0x1B,1
; 0000 0080     g1_on;
	IN   R30,0x37
	ORI  R30,0x10
	RJMP _0x2060003
; 0000 0081 }
; .FEND
;void motor2()
; 0000 0083 {
_motor2:
; .FSTART _motor2
; 0000 0084     m2_on;
	CBI  0x1B,2
; 0000 0085     g1_on;
	IN   R30,0x37
	ORI  R30,0x10
	RJMP _0x2060003
; 0000 0086 
; 0000 0087 }
; .FEND
;void motor3()
; 0000 0089 {
_motor3:
; .FSTART _motor3
; 0000 008A     m3_on;
	CBI  0x1B,3
; 0000 008B     g2_on;
	IN   R30,0x37
	ORI  R30,8
_0x2060003:
	OUT  0x37,R30
; 0000 008C }
	RET
; .FEND
;void give0() //timer1a
; 0000 008E {
_give0:
; .FSTART _give0
; 0000 008F     for(pill0[0]=0;pill0[0]<pill0[1];pill0[0]++)      //[한번에 먹는 약만큼]
	LDI  R30,LOW(0)
	STS  _pill0,R30
_0xC:
	__GETB1MN _pill0,1
	LDS  R26,_pill0
	CP   R26,R30
	BRSH _0xD
; 0000 0090     {
; 0000 0091         motor0();
	RCALL _motor0
; 0000 0092         wait(ONE);
	MOVW R26,R8
	RCALL _wait
; 0000 0093     }
	LDS  R30,_pill0
	SUBI R30,-LOW(1)
	STS  _pill0,R30
	RJMP _0xC
_0xD:
; 0000 0094 }
	RET
; .FEND
;
;void give1()
; 0000 0097 {
_give1:
; .FSTART _give1
; 0000 0098     for(pill1[0]=0;pill1[0]<pill1[1];pill1[0]++)
	LDI  R30,LOW(0)
	STS  _pill1,R30
_0xF:
	__GETB1MN _pill1,1
	LDS  R26,_pill1
	CP   R26,R30
	BRSH _0x10
; 0000 0099     {
; 0000 009A        motor1();
	RCALL _motor1
; 0000 009B        wait(ONE);
	MOVW R26,R8
	RCALL _wait
; 0000 009C     }
	LDS  R30,_pill1
	SUBI R30,-LOW(1)
	STS  _pill1,R30
	RJMP _0xF
_0x10:
; 0000 009D }
	RET
; .FEND
;
;void give2()
; 0000 00A0 {
_give2:
; .FSTART _give2
; 0000 00A1     for(pill2[0]=0;pill2[0]<pill2[1];pill2[0]++)
	LDI  R30,LOW(0)
	STS  _pill2,R30
_0x12:
	__GETB1MN _pill2,1
	LDS  R26,_pill2
	CP   R26,R30
	BRSH _0x13
; 0000 00A2     {
; 0000 00A3          motor2();
	RCALL _motor2
; 0000 00A4          wait(ONE);
	MOVW R26,R8
	RCALL _wait
; 0000 00A5     }
	LDS  R30,_pill2
	SUBI R30,-LOW(1)
	STS  _pill2,R30
	RJMP _0x12
_0x13:
; 0000 00A6 }
	RET
; .FEND
;
;void go(unsigned int t)
; 0000 00A9 {
_go:
; .FSTART _go
; 0000 00AA     target=t;
	ST   -Y,R27
	ST   -Y,R26
;	t -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	STS  _target,R30
	STS  _target+1,R31
; 0000 00AB     motor3();
	RCALL _motor3
; 0000 00AC     wait(t);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _wait
; 0000 00AD }
_0x2060002:
	ADIW R28,2
	RET
; .FEND
;
;char str2int(char str){ //시리얼 통신의 char data 변환
; 0000 00AF char str2int(char str){
_str2int:
; .FSTART _str2int
; 0000 00B0     if(str=='1') return 1;
	ST   -Y,R26
;	str -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x31)
	BRNE _0x14
	LDI  R30,LOW(1)
	RJMP _0x2060001
; 0000 00B1     else if(str=='2') return 2;
_0x14:
	LD   R26,Y
	CPI  R26,LOW(0x32)
	BRNE _0x16
	LDI  R30,LOW(2)
	RJMP _0x2060001
; 0000 00B2     else if(str=='3') return 3;
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x33)
	BRNE _0x18
	LDI  R30,LOW(3)
	RJMP _0x2060001
; 0000 00B3     else if(str=='0') return 0;
_0x18:
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRNE _0x1A
	LDI  R30,LOW(0)
; 0000 00B4 }
_0x1A:
_0x2060001:
	ADIW R28,1
	RET
; .FEND
;
;void run(){
; 0000 00B6 void run(){
_run:
; .FSTART _run
; 0000 00B7     unsigned char days=0;
; 0000 00B8     unsigned char meals=1;
; 0000 00B9     forward;
	ST   -Y,R17
	ST   -Y,R16
;	days -> R17
;	meals -> R16
	LDI  R17,0
	LDI  R16,1
	SBI  0x18,4
; 0000 00BA     go(PAUSE);
	MOVW R26,R4
	RCALL _go
; 0000 00BB    for(days=0; days<2;days++)//약을 며칠 복용하는지에 따라 다르게 수행
	LDI  R17,LOW(0)
_0x1C:
	CPI  R17,2
	BRSH _0x1D
; 0000 00BC     {
; 0000 00BD         for(meals=1; meals<=3; meals++) //아침,점심,저녁 약을 [하루 복용수]에 맞게
	LDI  R16,LOW(1)
_0x1F:
	CPI  R16,4
	BRSH _0x20
; 0000 00BE         {
; 0000 00BF             if (meals<=pill0[2]) give0();  //하루에 몇번 넣었는지가 [하루 복용횟수] 보다 적거나 같을 경우 실행
	__GETB1MN _pill0,2
	CP   R30,R16
	BRLO _0x21
	RCALL _give0
; 0000 00C0             if (meals<=pill1[2]) give1();
_0x21:
	__GETB1MN _pill1,2
	CP   R30,R16
	BRLO _0x22
	RCALL _give1
; 0000 00C1             if (meals<=pill2[2]) give2();
_0x22:
	__GETB1MN _pill2,2
	CP   R30,R16
	BRLO _0x23
	RCALL _give2
; 0000 00C2             forward;
_0x23:
	SBI  0x18,4
; 0000 00C3             beep(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _beep
; 0000 00C4             go(NEXT); //다음칸으로 이동
	MOVW R26,R10
	RCALL _go
; 0000 00C5         }
	SUBI R16,-1
	RJMP _0x1F
_0x20:
; 0000 00C6         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C7         beep(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _beep
; 0000 00C8     }
	SUBI R17,-1
	RJMP _0x1C
_0x1D:
; 0000 00C9     forward;
	SBI  0x18,4
; 0000 00CA     go(ENDLINE-position);
	LDS  R26,_position
	LDS  R27,_position+1
	MOVW R30,R6
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	RCALL _go
; 0000 00CB 
; 0000 00CC     backward;
	CBI  0x18,4
; 0000 00CD     go(ENDLINE); //back to start point
	MOVW R26,R6
	RCALL _go
; 0000 00CE     start=0;
	LDI  R30,LOW(0)
	STS  _start,R30
; 0000 00CF 
; 0000 00D0 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;interrupt [USART0_RXC] void usart0_rxc(void) //수신
; 0000 00D3 {
_usart0_rxc:
; .FSTART _usart0_rxc
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
; 0000 00D4     rxdata=UDR0;
	IN   R30,0xC
	STS  _rxdata,R30
; 0000 00D5     switch (rxdata)
	LDI  R31,0
; 0000 00D6     {
; 0000 00D7         case 'x':
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x27
; 0000 00D8             m0_t;
	IN   R30,0x1B
	LDI  R26,LOW(1)
	EOR  R30,R26
	OUT  0x1B,R30
; 0000 00D9             break;
	RJMP _0x26
; 0000 00DA         case 'y':
_0x27:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x28
; 0000 00DB             m3_t;
	IN   R30,0x1B
	LDI  R26,LOW(8)
	EOR  R30,R26
	OUT  0x1B,R30
; 0000 00DC             break;
	RJMP _0x26
; 0000 00DD         case 'z':
_0x28:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x29
; 0000 00DE             buzzer_t;
	IN   R30,0x1B
	LDI  R26,LOW(16)
	EOR  R30,R26
	OUT  0x1B,R30
; 0000 00DF             break;
	RJMP _0x26
; 0000 00E0         case 's':
_0x29:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00E1             init();
	RCALL _init
; 0000 00E2             string("1");
	__POINTW2MN _0x2B,0
	RJMP _0x47
; 0000 00E3             break;
; 0000 00E4         case 'e':
_0x2A:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00E5             string("5");
	__POINTW2MN _0x2B,2
	RCALL _string
; 0000 00E6             start=1;
	LDI  R30,LOW(1)
	STS  _start,R30
; 0000 00E7             break;
	RJMP _0x26
; 0000 00E8         case 'a':
_0x2C:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BREQ _0x2E
; 0000 00E9         case 'b':
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x2F
_0x2E:
; 0000 00EA         case 'c':
	RJMP _0x30
_0x2F:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x31
_0x30:
; 0000 00EB             unit[index]=rxdata;
	CALL SUBOPT_0x1
; 0000 00EC             index++;
; 0000 00ED             string("2");
	__POINTW2MN _0x2B,4
	RJMP _0x47
; 0000 00EE             break;
; 0000 00EF         case '0':
_0x31:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BREQ _0x33
; 0000 00F0         case '1':
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x34
_0x33:
; 0000 00F1         case '2':
	RJMP _0x35
_0x34:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x36
_0x35:
; 0000 00F2         case '3':
	RJMP _0x37
_0x36:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x26
_0x37:
; 0000 00F3             unit[index]=rxdata;
	CALL SUBOPT_0x1
; 0000 00F4             index++;
; 0000 00F5             string("3");
	__POINTW2MN _0x2B,6
	RCALL _string
; 0000 00F6             if(index==3)
	LDS  R26,_index
	CPI  R26,LOW(0x3)
	BRNE _0x39
; 0000 00F7             {
; 0000 00F8                 index=0;
	LDI  R30,LOW(0)
	STS  _index,R30
; 0000 00F9                 switch(unit[0])
	LDS  R30,_unit
	LDI  R31,0
; 0000 00FA                 {
; 0000 00FB                     case 'a' :
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x3D
; 0000 00FC                         pill0[1]=str2int(unit[1]);
	CALL SUBOPT_0x2
	__PUTB1MN _pill0,1
; 0000 00FD                         pill0[2]=str2int(unit[2]);
	CALL SUBOPT_0x3
	__PUTB1MN _pill0,2
; 0000 00FE                         break;
	RJMP _0x3C
; 0000 00FF                     case 'b' :
_0x3D:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x3E
; 0000 0100                         pill1[1]=str2int(unit[1]);
	CALL SUBOPT_0x2
	__PUTB1MN _pill1,1
; 0000 0101                         pill1[2]=str2int(unit[2]);
	CALL SUBOPT_0x3
	__PUTB1MN _pill1,2
; 0000 0102                         break;
	RJMP _0x3C
; 0000 0103                     case 'c':
_0x3E:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x3C
; 0000 0104                         pill2[1]=str2int(unit[1]);
	CALL SUBOPT_0x2
	__PUTB1MN _pill2,1
; 0000 0105                         pill2[2]=str2int(unit[2]);
	CALL SUBOPT_0x3
	__PUTB1MN _pill2,2
; 0000 0106                         break;
; 0000 0107                 }
_0x3C:
; 0000 0108                 string("4");
	__POINTW2MN _0x2B,8
_0x47:
	RCALL _string
; 0000 0109              }
; 0000 010A              break;
_0x39:
; 0000 010B     }
_0x26:
; 0000 010C }
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

	.DSEG
_0x2B:
	.BYTE 0xA
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 010F {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0110     step1++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0111     if(step1>=ONE)
	__CPWRR 12,13,8,9
	BRLO _0x40
; 0000 0112     {
; 0000 0113         m0_off;
	SBI  0x1B,0
; 0000 0114         m1_off;
	SBI  0x1B,1
; 0000 0115         m2_off;
	SBI  0x1B,2
; 0000 0116         g1_off; //disable ocie1a
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
; 0000 0117         step1=0;
	CLR  R12
	CLR  R13
; 0000 0118     }
; 0000 0119 }
_0x40:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 011B {
_timer1_compb_isr:
; .FSTART _timer1_compb_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 011C     step2++;
	LDI  R26,LOW(_step2)
	LDI  R27,HIGH(_step2)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 011D     if(step2>=target)
	LDS  R30,_target
	LDS  R31,_target+1
	LDS  R26,_step2
	LDS  R27,_step2+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x41
; 0000 011E     {
; 0000 011F         m3_off;
	SBI  0x1B,3
; 0000 0120         g2_off; //disable ocie1b
	IN   R30,0x37
	ANDI R30,0XF7
	OUT  0x37,R30
; 0000 0121         position+=step2;
	LDS  R30,_step2
	LDS  R31,_step2+1
	LDS  R26,_position
	LDS  R27,_position+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _position,R30
	STS  _position+1,R31
; 0000 0122         step2=0;
	LDI  R30,LOW(0)
	STS  _step2,R30
	STS  _step2+1,R30
; 0000 0123     }
; 0000 0124 }
_0x41:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;interrupt [USART0_DRE] void usart0_dre(void)
; 0000 0127 {
_usart0_dre:
; .FSTART _usart0_dre
	ST   -Y,R30
; 0000 0128     UDR0=txdata;
	LDS  R30,_txdata
	OUT  0xC,R30
; 0000 0129     UCSR0B &= 0xDF; // UDRE = 0 USCR0B = 0b10011000
	CBI  0xA,5
; 0000 012A }
	LD   R30,Y+
	RETI
; .FEND
;
;
;/*
;
;    M        STEP    EN      DIR     TIM
;    0        PB5     PA0     PB3     OC1a
;    1        PB5     PA1     PB3     OC1a
;    2        PB5     PA2     PB3     OC1a
;    3        PB6     PA3     PB4     OC1b
;
;
;*/
;
;void main(void)
; 0000 0139 {
_main:
; .FSTART _main
; 0000 013A     DDRE=0b00000010; // 1:txd0 0:rxd0
	LDI  R30,LOW(2)
	OUT  0x2,R30
; 0000 013B     DDRB=0xFF;   //3,4: dir 5,6: step
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 013C     DDRA=0x1F;
	LDI  R30,LOW(31)
	OUT  0x1A,R30
; 0000 013D     SREG=0x80;
	LDI  R30,LOW(128)
	OUT  0x3F,R30
; 0000 013E     TCCR1A=0x50; //TIMER1a, TIMER1b on Timer1c off
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 013F     TCCR1B=0x0A;
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 0140     TCCR1C=0x00;
	LDI  R30,LOW(0)
	STS  122,R30
; 0000 0141     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0142     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0143     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0144     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0145     OCR1CH=0x00;
	STS  121,R30
; 0000 0146     OCR1CL=0x00;
	STS  120,R30
; 0000 0147     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0148     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0149     TIMSK=0x00;  //0001 1000 OCIE1A, OCIE1B interrupt enable
	OUT  0x37,R30
; 0000 014A     ETIMSK=0x00;
	STS  125,R30
; 0000 014B 
; 0000 014C     init();
	RCALL _init
; 0000 014D     BTinit();
	RCALL _BTinit
; 0000 014E     vel_f5();
	RCALL _vel_f5
; 0000 014F 
; 0000 0150     while(1){
_0x42:
; 0000 0151         if(start==1) run();
	LDS  R26,_start
	CPI  R26,LOW(0x1)
	BRNE _0x45
	RCALL _run
; 0000 0152     }
_0x45:
	RJMP _0x42
; 0000 0153 }
_0x46:
	RJMP _0x46
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_step2:
	.BYTE 0x2
_start:
	.BYTE 0x1
_target:
	.BYTE 0x2
_position:
	.BYTE 0x2
_txdata:
	.BYTE 0x2
_rxdata:
	.BYTE 0x1
_pill0:
	.BYTE 0x3
_pill1:
	.BYTE 0x3
_pill2:
	.BYTE 0x3
_unit:
	.BYTE 0x3
_index:
	.BYTE 0x1
_sp1:
	.BYTE 0x2
_sp2:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	LDS  R30,_index
	LDI  R31,0
	SUBI R30,LOW(-_unit)
	SBCI R31,HIGH(-_unit)
	LDS  R26,_rxdata
	STD  Z+0,R26
	LDS  R30,_index
	SUBI R30,-LOW(1)
	STS  _index,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETB2MN _unit,1
	JMP  _str2int

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETB2MN _unit,2
	JMP  _str2int


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

;END OF CODE MARKER
__END_OF_CODE:
