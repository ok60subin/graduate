
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
	.DEF _txdata=R5
	.DEF _rxdata=R4
	.DEF _g1=R6
	.DEF _g1_msb=R7
	.DEF _g2=R8
	.DEF _g2_msb=R9
	.DEF _step1=R10
	.DEF _step1_msb=R11
	.DEF _end1=R12
	.DEF _end1_msb=R13

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
	JMP  0x00
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
	.DB  0x0,0x0,0xC4,0x9
	.DB  0xC4,0x9,0x0,0x0
	.DB  0x20,0x3

_0x3:
	.DB  0xD0,0x7
_0x4:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x30,0x30,0x30,0x30,0x30,0x30
	.DB  0x30,0x30,0x30,0x30
_0x0:
	.DB  0x4D,0x30,0x0,0x4D,0x31,0x0,0x4D,0x32
	.DB  0x0,0x4D,0x33,0x0,0x45,0x31,0x0,0x53
	.DB  0x31,0x0,0x45,0x32,0x0,0x53,0x32,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _end2
	.DW  _0x3*2

	.DW  0x03
	.DW  _0x3B
	.DW  _0x0*2

	.DW  0x03
	.DW  _0x3B+3
	.DW  _0x0*2+3

	.DW  0x03
	.DW  _0x3B+6
	.DW  _0x0*2+6

	.DW  0x03
	.DW  _0x3B+9
	.DW  _0x0*2+9

	.DW  0x03
	.DW  _0x3B+12
	.DW  _0x0*2+12

	.DW  0x03
	.DW  _0x3B+15
	.DW  _0x0*2+15

	.DW  0x03
	.DW  _0x3B+18
	.DW  _0x0*2+18

	.DW  0x03
	.DW  _0x3B+21
	.DW  _0x0*2+21

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
;#define g1_ccw PORTB&=0xF7
;#define g2_ccw PORTB&=0xEF
;
;#define g1_cw PORTB|=0x08
;#define g2_cw PORTB|=0x10
;
;#define g1_t PORTB^=0x08
;#define g2_t PORTB^=0x10
;
;
;unsigned char txdata=0; //시리얼 통신의 송신데이터 저장 변수
;unsigned char rxdata=0; //시리얼 통신의 수신데이터 저장 변수
;
;unsigned int g1=2500;  //속
;unsigned int g2=2500;
;
;unsigned int step1=0;
;unsigned int end1=800;
;unsigned int step2=0;
;unsigned int end2=2000;

	.DSEG
;
;unsigned char left=0;
;unsigned char mid=0;
;unsigned char right=0;
;
;void init()
; 0000 0034 {

	.CSEG
_init:
; .FSTART _init
; 0000 0035     m0_off;
	SBI  0x1B,0
; 0000 0036     m1_off;
	SBI  0x1B,1
; 0000 0037     m2_off;
	SBI  0x1B,2
; 0000 0038     m3_off;
	SBI  0x1B,3
; 0000 0039     step1=0;
	CLR  R10
	CLR  R11
; 0000 003A     step2=0;
	LDI  R30,LOW(0)
	STS  _step2,R30
	STS  _step2+1,R30
; 0000 003B }
	RET
; .FEND
;void BTinit(void)
; 0000 003D {
_BTinit:
; .FSTART _BTinit
; 0000 003E     UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 003F     UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0040     UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0041     UBRR0H=0;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0042     UBRR0L=103;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 0043 }
	RET
; .FEND
;
;void transmit() //after setting txdata
; 0000 0046 {
_transmit:
; .FSTART _transmit
; 0000 0047      UCSR0B |= 0x20;
	SBI  0xA,5
; 0000 0048      delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0049 }
	RET
; .FEND
;unsigned char* dec(int data)
; 0000 004B {
_dec:
; .FSTART _dec
; 0000 004C     unsigned char i;
; 0000 004D     unsigned char sdata[10]={'0','0','0','0','0','0','0','0','0','0'};
; 0000 004E     unsigned char tdata[10]={0,0,0,0,0,0,0,0,0,0};
; 0000 004F     for(i=0;i<4;i++)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,20
	LDI  R24,20
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x4*2)
	LDI  R31,HIGH(_0x4*2)
	CALL __INITLOCB
	ST   -Y,R17
;	data -> Y+21
;	i -> R17
;	sdata -> Y+11
;	tdata -> Y+1
	LDI  R17,LOW(0)
_0x6:
	CPI  R17,4
	BRSH _0x7
; 0000 0050     {
; 0000 0051         sdata[i]=(data % 10)+ '0';
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,11
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
; 0000 0052         data/=10;
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+21,R30
	STD  Y+21+1,R31
; 0000 0053         if (data==0) break;
	SBIW R30,0
	BREQ _0x7
; 0000 0054     }
	SUBI R17,-1
	RJMP _0x6
_0x7:
; 0000 0055     for(i=0;i<10;i++)
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,10
	BRSH _0xB
; 0000 0056     {
; 0000 0057         tdata[i]=sdata[3-i];
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOV  R30,R17
	LDI  R31,0
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R28
	ADIW R26,11
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R22
	ST   X,R30
; 0000 0058     }
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 0059 
; 0000 005A     return tdata;
	MOVW R30,R28
	ADIW R30,1
	LDD  R17,Y+0
	ADIW R28,23
	RET
; 0000 005B }
; .FEND
;void string(char *str)
; 0000 005D {
_string:
; .FSTART _string
; 0000 005E     unsigned int i=0;
; 0000 005F     for(i=0; str[i]; i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*str -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0xD:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BREQ _0xE
; 0000 0060     {
; 0000 0061         txdata=str[i];
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R5,X
; 0000 0062         transmit();
	RCALL _transmit
; 0000 0063     }
	__ADDWRN 16,17,1
	RJMP _0xD
_0xE:
; 0000 0064 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;void vel_f5()
; 0000 0066 {
_vel_f5:
; .FSTART _vel_f5
; 0000 0067     OCR1AH=(g1>>8);
	MOV  R30,R7
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
; 0000 0068     OCR1AL=g1;
	OUT  0x2A,R6
; 0000 0069     OCR1BH=(g2>>8);
	MOV  R30,R9
	ANDI R31,HIGH(0x0)
	OUT  0x29,R30
; 0000 006A     OCR1BL=g2;
	OUT  0x28,R8
; 0000 006B }
	RET
; .FEND
;
;void adj_end1(){
; 0000 006D void adj_end1(){
_adj_end1:
; .FSTART _adj_end1
; 0000 006E     string(dec(end1));
	CALL SUBOPT_0x0
; 0000 006F     while (left==0){
_0xF:
	LDS  R30,_left
	CPI  R30,0
	BRNE _0x11
; 0000 0070         if(mid==1){
	LDS  R26,_mid
	CPI  R26,LOW(0x1)
	BRNE _0x12
; 0000 0071             end1+=100;
	MOVW R30,R12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOVW R12,R30
; 0000 0072             mid=0;
	LDI  R30,LOW(0)
	STS  _mid,R30
; 0000 0073             string(dec(end1));
	CALL SUBOPT_0x0
; 0000 0074         }
; 0000 0075         if(right==1){
_0x12:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x13
; 0000 0076             end1-=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__SUBWRR 12,13,30,31
; 0000 0077             right=0;
	LDI  R30,LOW(0)
	STS  _right,R30
; 0000 0078             string(dec(end1));
	CALL SUBOPT_0x0
; 0000 0079         }
; 0000 007A     }
_0x13:
	RJMP _0xF
_0x11:
; 0000 007B     left=0;
	RJMP _0x2060002
; 0000 007C }
; .FEND
;void adj_end2(){
; 0000 007D void adj_end2(){
_adj_end2:
; .FSTART _adj_end2
; 0000 007E     string(dec(end2));
	CALL SUBOPT_0x1
; 0000 007F     while (left==0){
_0x14:
	LDS  R30,_left
	CPI  R30,0
	BRNE _0x16
; 0000 0080         if(mid==1){
	LDS  R26,_mid
	CPI  R26,LOW(0x1)
	BRNE _0x17
; 0000 0081             end2+=100;
	LDS  R30,_end2
	LDS  R31,_end2+1
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _end2,R30
	STS  _end2+1,R31
; 0000 0082             mid=0;
	LDI  R30,LOW(0)
	STS  _mid,R30
; 0000 0083             string(dec(end2));
	CALL SUBOPT_0x1
; 0000 0084         }
; 0000 0085         if(right==1){
_0x17:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x18
; 0000 0086             end2-=100;
	LDS  R30,_end2
	LDS  R31,_end2+1
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	STS  _end2,R30
	STS  _end2+1,R31
; 0000 0087             right=0;
	LDI  R30,LOW(0)
	STS  _right,R30
; 0000 0088             string(dec(end2));
	CALL SUBOPT_0x1
; 0000 0089         }
; 0000 008A     }
_0x18:
	RJMP _0x14
_0x16:
; 0000 008B     left=0;
	RJMP _0x2060002
; 0000 008C }
; .FEND
;void speed1(){
; 0000 008D void speed1(){
_speed1:
; .FSTART _speed1
; 0000 008E     string(dec(g1));
	CALL SUBOPT_0x2
; 0000 008F     while (left==0){
_0x19:
	LDS  R30,_left
	CPI  R30,0
	BRNE _0x1B
; 0000 0090         if(mid==1){
	LDS  R26,_mid
	CPI  R26,LOW(0x1)
	BRNE _0x1C
; 0000 0091             g1+=100;
	MOVW R30,R6
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOVW R6,R30
; 0000 0092             mid=0;
	LDI  R30,LOW(0)
	STS  _mid,R30
; 0000 0093             string(dec(g1));
	CALL SUBOPT_0x2
; 0000 0094         }
; 0000 0095         if(right==1){
_0x1C:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x1D
; 0000 0096             g1-=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__SUBWRR 6,7,30,31
; 0000 0097             right=0;
	LDI  R30,LOW(0)
	STS  _right,R30
; 0000 0098             string(dec(g1));
	CALL SUBOPT_0x2
; 0000 0099         }
; 0000 009A     }
_0x1D:
	RJMP _0x19
_0x1B:
; 0000 009B     vel_f5();
	RJMP _0x2060001
; 0000 009C     left=0;
; 0000 009D }
; .FEND
;void speed2(){
; 0000 009E void speed2(){
_speed2:
; .FSTART _speed2
; 0000 009F     string(dec(g2));
	CALL SUBOPT_0x3
; 0000 00A0     while (left==0){
_0x1E:
	LDS  R30,_left
	CPI  R30,0
	BRNE _0x20
; 0000 00A1         if(mid==1){
	LDS  R26,_mid
	CPI  R26,LOW(0x1)
	BRNE _0x21
; 0000 00A2             g2+=100;
	MOVW R30,R8
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOVW R8,R30
; 0000 00A3             mid=0;
	LDI  R30,LOW(0)
	STS  _mid,R30
; 0000 00A4             string(dec(g2));
	CALL SUBOPT_0x3
; 0000 00A5         }
; 0000 00A6         if(right==1){
_0x21:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x22
; 0000 00A7             g2-=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__SUBWRR 8,9,30,31
; 0000 00A8             right=0;
	LDI  R30,LOW(0)
	STS  _right,R30
; 0000 00A9             string(dec(g2));
	CALL SUBOPT_0x3
; 0000 00AA         }
; 0000 00AB     }
_0x22:
	RJMP _0x1E
_0x20:
; 0000 00AC     vel_f5();
_0x2060001:
	RCALL _vel_f5
; 0000 00AD     left=0;
_0x2060002:
	LDI  R30,LOW(0)
	STS  _left,R30
; 0000 00AE }
	RET
; .FEND
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00B0 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B1     step1++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00B2     if(step1==end1)
	__CPWRR 12,13,10,11
	BRNE _0x23
; 0000 00B3     {
; 0000 00B4         m0_off;
	SBI  0x1B,0
; 0000 00B5         m1_off;
	SBI  0x1B,1
; 0000 00B6         m2_off;
	SBI  0x1B,2
; 0000 00B7         g1_off; //disable ocie1a
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
; 0000 00B8         step1=0;
	CLR  R10
	CLR  R11
; 0000 00B9     }
; 0000 00BA }
_0x23:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;/*
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
;{
;    step2++;
;    if(step2==end2)
;    {
;        m3_off;
;        g2_off; //disable ocie1b
;        step2=0;
;    }
;}
;*/
;interrupt [USART0_RXC] void usart0_rxc(void) //수신
; 0000 00C8 {
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
; 0000 00C9     rxdata=UDR0;
	IN   R4,12
; 0000 00CA     switch (rxdata)
	MOV  R30,R4
	LDI  R31,0
; 0000 00CB     {
; 0000 00CC         case '0':
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x27
; 0000 00CD             left=1;
	LDI  R30,LOW(1)
	STS  _left,R30
; 0000 00CE             break;
	RJMP _0x26
; 0000 00CF         case '1':
_0x27:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x28
; 0000 00D0             mid=1;
	LDI  R30,LOW(1)
	STS  _mid,R30
; 0000 00D1             break;
	RJMP _0x26
; 0000 00D2         case '2':
_0x28:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x29
; 0000 00D3             right=1;
	LDI  R30,LOW(1)
	STS  _right,R30
; 0000 00D4             break;
	RJMP _0x26
; 0000 00D5         case '3':
_0x29:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00D6             g1_cw;
	SBI  0x18,3
; 0000 00D7             break;
	RJMP _0x26
; 0000 00D8         case '4':
_0x2A:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x2B
; 0000 00D9             g1_ccw;
	CBI  0x18,3
; 0000 00DA             break;
	RJMP _0x26
; 0000 00DB         case '5':
_0x2B:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x2C
; 0000 00DC             g2_cw;
	SBI  0x18,4
; 0000 00DD             break;
	RJMP _0x26
; 0000 00DE         case '6':
_0x2C:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0x2D
; 0000 00DF             g2_ccw;
	CBI  0x18,4
; 0000 00E0             break;
	RJMP _0x26
; 0000 00E1         case '7':
_0x2D:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00E2             g1+=100;
	MOVW R30,R6
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOVW R6,R30
; 0000 00E3             vel_f5();
	RJMP _0x6C
; 0000 00E4             break;
; 0000 00E5         case '8':
_0x2E:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x2F
; 0000 00E6             g1-=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__SUBWRR 6,7,30,31
; 0000 00E7             vel_f5();
	RJMP _0x6C
; 0000 00E8             break;
; 0000 00E9         case '9':
_0x2F:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0x30
; 0000 00EA             g2+=100;
	MOVW R30,R8
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	MOVW R8,R30
; 0000 00EB             vel_f5();
	RJMP _0x6C
; 0000 00EC             break;
; 0000 00ED         case 'a':
_0x30:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x26
; 0000 00EE             g2-=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__SUBWRR 8,9,30,31
; 0000 00EF             vel_f5();
_0x6C:
	RCALL _vel_f5
; 0000 00F0             break;
; 0000 00F1 
; 0000 00F2     }
_0x26:
; 0000 00F3 }
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
;interrupt [USART0_DRE] void usart0_dre(void)  //송신하고 나서 송신 금지.
; 0000 00F6 {
_usart0_dre:
; .FSTART _usart0_dre
; 0000 00F7     UDR0=txdata;
	OUT  0xC,R5
; 0000 00F8     UCSR0B &= 0xDF; // UDRE = 0 USCR0B = 0b10011000
	CBI  0xA,5
; 0000 00F9 }
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
; 0000 0108 {
_main:
; .FSTART _main
; 0000 0109     unsigned char max=7;
; 0000 010A     signed char menu=0;
; 0000 010B     DDRE=0b10000010; //7: buzzer 1:txd0 0:rxd0
;	max -> R17
;	menu -> R16
	LDI  R17,7
	LDI  R16,0
	LDI  R30,LOW(130)
	OUT  0x2,R30
; 0000 010C     DDRB=0b01111000;   //3,4: dir 5,6: step
	LDI  R30,LOW(120)
	OUT  0x17,R30
; 0000 010D     DDRA=0x0F;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 010E     SREG=0x80;
	LDI  R30,LOW(128)
	OUT  0x3F,R30
; 0000 010F     TCCR1A=0x50; //TIMER1a, TIMER1b on Timer1c off
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 0110     TCCR1B=0x0A;
	LDI  R30,LOW(10)
	OUT  0x2E,R30
; 0000 0111     OCR1AL=0x00;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
; 0000 0112     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0113     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0114     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0115     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0116     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0117     TIMSK=0x00;  //0001 1000 OCIE1A, OCIE1B interrupt enable
	OUT  0x37,R30
; 0000 0118 
; 0000 0119     init();
	RCALL _init
; 0000 011A     BTinit();
	RCALL _BTinit
; 0000 011B     vel_f5();
	RCALL _vel_f5
; 0000 011C 
; 0000 011D     while(1){
_0x32:
; 0000 011E           if (menu<0) menu=max;
	CPI  R16,0
	BRGE _0x35
	MOV  R16,R17
; 0000 011F           if (menu>max) menu=0;
_0x35:
	MOV  R30,R17
	MOV  R26,R16
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x36
	LDI  R16,LOW(0)
; 0000 0120           switch (menu)
_0x36:
	MOV  R30,R16
	LDI  R31,0
	SBRC R30,7
	SER  R31
; 0000 0121           {
; 0000 0122             case 0:
	SBIW R30,0
	BRNE _0x3A
; 0000 0123                 string("M0");
	__POINTW2MN _0x3B,0
	RCALL _string
; 0000 0124                 while(mid==0)
_0x3C:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x3E
; 0000 0125                 {
; 0000 0126                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x3F
; 0000 0127                     {
; 0000 0128                         left=0;
	CALL SUBOPT_0x4
; 0000 0129                         m0_t;
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5
; 0000 012A                         g1_on;
; 0000 012B                     }
; 0000 012C                     if(right==1)
_0x3F:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x40
; 0000 012D                     {
; 0000 012E                         menu-=2;
	CALL SUBOPT_0x6
; 0000 012F                         right=0;
; 0000 0130                         break;
	RJMP _0x3E
; 0000 0131                     }
; 0000 0132 
; 0000 0133                 }
_0x40:
	RJMP _0x3C
_0x3E:
; 0000 0134                 menu++;
	RJMP _0x6D
; 0000 0135                 mid=0;
; 0000 0136                 break;
; 0000 0137             case 1:
_0x3A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x41
; 0000 0138                 string("M1");
	__POINTW2MN _0x3B,3
	RCALL _string
; 0000 0139                 while(mid==0)
_0x42:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x44
; 0000 013A                 {
; 0000 013B                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x45
; 0000 013C                     {
; 0000 013D                         left=0;
	CALL SUBOPT_0x4
; 0000 013E                         m1_t;
	LDI  R26,LOW(2)
	CALL SUBOPT_0x5
; 0000 013F                         g1_on;
; 0000 0140                     }
; 0000 0141                     if(right==1)
_0x45:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x46
; 0000 0142                     {
; 0000 0143                         menu-=2;
	CALL SUBOPT_0x6
; 0000 0144                         right=0;
; 0000 0145                         break;
	RJMP _0x44
; 0000 0146                     }
; 0000 0147 
; 0000 0148                 }
_0x46:
	RJMP _0x42
_0x44:
; 0000 0149                 menu++;
	RJMP _0x6D
; 0000 014A                 mid=0;
; 0000 014B                 break;
; 0000 014C             case 2:
_0x41:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x47
; 0000 014D                 string("M2");
	__POINTW2MN _0x3B,6
	RCALL _string
; 0000 014E                 while(mid==0)
_0x48:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x4A
; 0000 014F                 {
; 0000 0150                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x4B
; 0000 0151                     {
; 0000 0152                         left=0;
	CALL SUBOPT_0x4
; 0000 0153                         m2_t;
	LDI  R26,LOW(4)
	CALL SUBOPT_0x5
; 0000 0154                         g1_on;
; 0000 0155                     }
; 0000 0156                     if(right==1)
_0x4B:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x4C
; 0000 0157                     {
; 0000 0158                         menu-=2;
	CALL SUBOPT_0x6
; 0000 0159                         right=0;
; 0000 015A                         break;
	RJMP _0x4A
; 0000 015B                     }
; 0000 015C 
; 0000 015D                 }
_0x4C:
	RJMP _0x48
_0x4A:
; 0000 015E                 menu++;
	RJMP _0x6D
; 0000 015F                 mid=0;
; 0000 0160                 break;
; 0000 0161             case 3:
_0x47:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4D
; 0000 0162                 string("M3");
	__POINTW2MN _0x3B,9
	RCALL _string
; 0000 0163                 while(mid==0)
_0x4E:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x50
; 0000 0164                 {
; 0000 0165                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x51
; 0000 0166                     {
; 0000 0167                         left=0;
	CALL SUBOPT_0x4
; 0000 0168                         m3_t;
	LDI  R26,LOW(8)
	EOR  R30,R26
	OUT  0x1B,R30
; 0000 0169                         //g2_on;
; 0000 016A                     }
; 0000 016B                     if(right==1)
_0x51:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x52
; 0000 016C                     {
; 0000 016D                         menu-=2;
	CALL SUBOPT_0x6
; 0000 016E                         right=0;
; 0000 016F                         break;
	RJMP _0x50
; 0000 0170                     }
; 0000 0171 
; 0000 0172                 }
_0x52:
	RJMP _0x4E
_0x50:
; 0000 0173                 menu++;
	RJMP _0x6D
; 0000 0174                 mid=0;
; 0000 0175                 break;
; 0000 0176 
; 0000 0177             case 4:
_0x4D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x53
; 0000 0178                 string("E1");
	__POINTW2MN _0x3B,12
	RCALL _string
; 0000 0179                 while(mid==0)
_0x54:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x56
; 0000 017A                 {
; 0000 017B                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x57
; 0000 017C                     {
; 0000 017D                         left=0;
	LDI  R30,LOW(0)
	STS  _left,R30
; 0000 017E                         adj_end1();
	RCALL _adj_end1
; 0000 017F                     }
; 0000 0180                     if(right==1)
_0x57:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x58
; 0000 0181                     {
; 0000 0182                         menu-=2;
	CALL SUBOPT_0x6
; 0000 0183                         right=0;
; 0000 0184                         break;
	RJMP _0x56
; 0000 0185                     }
; 0000 0186 
; 0000 0187                 }
_0x58:
	RJMP _0x54
_0x56:
; 0000 0188                 menu++;
	RJMP _0x6D
; 0000 0189                 mid=0;
; 0000 018A                 break;
; 0000 018B             case 5:
_0x53:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x59
; 0000 018C                 string("S1");
	__POINTW2MN _0x3B,15
	RCALL _string
; 0000 018D                 while(mid==0)
_0x5A:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x5C
; 0000 018E                 {
; 0000 018F                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x5D
; 0000 0190                     {
; 0000 0191                         left=0;
	LDI  R30,LOW(0)
	STS  _left,R30
; 0000 0192                         speed1();
	RCALL _speed1
; 0000 0193                     }
; 0000 0194                     if(right==1)
_0x5D:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x5E
; 0000 0195                     {
; 0000 0196                         menu-=2;
	CALL SUBOPT_0x6
; 0000 0197                         right=0;
; 0000 0198                         break;
	RJMP _0x5C
; 0000 0199                     }
; 0000 019A 
; 0000 019B                 }
_0x5E:
	RJMP _0x5A
_0x5C:
; 0000 019C                 menu++;
	RJMP _0x6D
; 0000 019D                 mid=0;
; 0000 019E                 break;
; 0000 019F             case 6:
_0x59:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x5F
; 0000 01A0                 string("E2");
	__POINTW2MN _0x3B,18
	RCALL _string
; 0000 01A1                 while(mid==0)
_0x60:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x62
; 0000 01A2                 {
; 0000 01A3                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x63
; 0000 01A4                     {
; 0000 01A5                         left=0;
	LDI  R30,LOW(0)
	STS  _left,R30
; 0000 01A6                         adj_end2();
	RCALL _adj_end2
; 0000 01A7                     }
; 0000 01A8                     if(right==1)
_0x63:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x64
; 0000 01A9                     {
; 0000 01AA                         menu-=2;
	CALL SUBOPT_0x6
; 0000 01AB                         right=0;
; 0000 01AC                         break;
	RJMP _0x62
; 0000 01AD                     }
; 0000 01AE 
; 0000 01AF                 }
_0x64:
	RJMP _0x60
_0x62:
; 0000 01B0                 menu++;
	RJMP _0x6D
; 0000 01B1                 mid=0;
; 0000 01B2                 break;
; 0000 01B3             case 7:
_0x5F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x39
; 0000 01B4                 string("S2");
	__POINTW2MN _0x3B,21
	RCALL _string
; 0000 01B5                 while(mid==0)
_0x66:
	LDS  R30,_mid
	CPI  R30,0
	BRNE _0x68
; 0000 01B6                 {
; 0000 01B7                     if(left==1)
	LDS  R26,_left
	CPI  R26,LOW(0x1)
	BRNE _0x69
; 0000 01B8                     {
; 0000 01B9                         left=0;
	LDI  R30,LOW(0)
	STS  _left,R30
; 0000 01BA                         speed2();
	RCALL _speed2
; 0000 01BB                     }
; 0000 01BC                     if(right==1)
_0x69:
	LDS  R26,_right
	CPI  R26,LOW(0x1)
	BRNE _0x6A
; 0000 01BD                     {
; 0000 01BE                         menu-=2;
	CALL SUBOPT_0x6
; 0000 01BF                         right=0;
; 0000 01C0                         break;
	RJMP _0x68
; 0000 01C1                     }
; 0000 01C2 
; 0000 01C3                 }
_0x6A:
	RJMP _0x66
_0x68:
; 0000 01C4                 menu++;
_0x6D:
	SUBI R16,-1
; 0000 01C5                 mid=0;
	LDI  R30,LOW(0)
	STS  _mid,R30
; 0000 01C6                 break;
; 0000 01C7                 /*
; 0000 01C8             case x:
; 0000 01C9                 string("메뉴이름");
; 0000 01CA                 while(mid==0)
; 0000 01CB                 {
; 0000 01CC                     if(left==1)
; 0000 01CD                     {
; 0000 01CE                         left=0;
; 0000 01CF                         메뉴진입();
; 0000 01D0                     }
; 0000 01D1                     if(right==1)
; 0000 01D2                     {
; 0000 01D3                         menu-=2;
; 0000 01D4                         right=0;
; 0000 01D5                         break;
; 0000 01D6                     }
; 0000 01D7 
; 0000 01D8                 }
; 0000 01D9                 menu++;
; 0000 01DA                 mid=0;
; 0000 01DB                 break;
; 0000 01DC                 */
; 0000 01DD           }
_0x39:
; 0000 01DE     }
	RJMP _0x32
; 0000 01DF }
_0x6B:
	RJMP _0x6B
; .FEND

	.DSEG
_0x3B:
	.BYTE 0x18
;/*
;void 함수이름(){
;    while (left==0){
;        if(mid==1){
;
;        }
;        if(right==1){
;
;        }
;    left=0;
;}
;
;*/
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
_end2:
	.BYTE 0x2
_left:
	.BYTE 0x1
_mid:
	.BYTE 0x1
_right:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	MOVW R26,R12
	CALL _dec
	MOVW R26,R30
	JMP  _string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	LDS  R26,_end2
	LDS  R27,_end2+1
	CALL _dec
	MOVW R26,R30
	JMP  _string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	MOVW R26,R6
	CALL _dec
	MOVW R26,R30
	JMP  _string

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	MOVW R26,R8
	CALL _dec
	MOVW R26,R30
	JMP  _string

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	STS  _left,R30
	IN   R30,0x1B
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	EOR  R30,R26
	OUT  0x1B,R30
	IN   R30,0x37
	ORI  R30,0x10
	OUT  0x37,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	SUBI R16,LOW(2)
	LDI  R30,LOW(0)
	STS  _right,R30
	RET


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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
