		AREA    |.text|, CODE, READONLY
        ALIGN

; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000		; GPIO Port D (APB) base: 0x4000.7000 (p416 datasheet de lm3s9B92.pdf)

; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
GPIO_O_DIR  		EQU 	0x00000400  ; GPIO Direction (p417 datasheet de lm3s9B92.pdf)

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
GPIO_O_DR2R  		EQU 	0x00000500  ; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; Pul_up
GPIO_I_PUR  		EQU 	0x00000510  ; GPIO Pull-Up (p432 datasheet de lm3s9B92.pdf)

; Broches select
BROCHE4				EQU		0x10		; led1 broche 4
BROCHE5				EQU		0x20		; led2 broche 5
BROCHE4_5			EQU		0x30		; led1 & led2 sur broche 4 et 5

        EXPORT	LedsInit
        EXPORT	LedOn1
        EXPORT  ToggleLed1
        EXPORT  LedOn2
        EXPORT  ToggleLed2
        EXPORT  LedsOn	
        EXPORT	ToggleLeds
        EXPORT  LedsOff

		; ;; Enable the Port F peripheral clock 		(p291 datasheet de lm3s9B96.pdf)
LedsInit
		ldr r5, = SYSCTL_PERIPH_GPIO 			;; RCGC2
        ldr r0, [r5]                            
        orr r0, r0, #0x00000020 					;; Enable clock sur GPIO F où sont branchés les leds en utilisant un ou binaire pour pas écraser
													;; orr = mot-clé montré par chatgpt
        str r0, [r5]

		; ;;														 									
		
		; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)                         
		nop 	 								;; tres tres important....
		nop 
		nop 										;; pas necessaire en simu ou en debbug step by step...
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION LED
        
        ldr r0, = BROCHE4_5 	
        
		ldr r5, = GPIO_PORTF_BASE + GPIO_O_DIR 	;; 1 Pin du portF en sortie (broche 4 : 00010000)
        str r0, [r5]
		
        
		ldr r5, = GPIO_PORTF_BASE + GPIO_O_DEN	;; Enable Digital Function
        str r0, [r5]
		
        
		ldr r5, = GPIO_PORTF_BASE + GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
        str r0, [r5]
        
		ldr r5, = GPIO_PORTF_BASE + (BROCHE4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1&2
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration LED
        
        BX LR                                    

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Fonctions LED
LedOn1
	ldr r0, [r5]
	orr r0, #BROCHE4
	str r0, [r5]
	BX LR
	
ToggleLed1
	ldr r0, [r5]
	eor r0, #BROCHE4
	str r0, [r5]
	BX LR
	
LedOn2
	ldr r0, [r5]
	orr r0, #BROCHE5
	str r0, [r5]
	BX LR
	
ToggleLed2
	ldr r0, [r5]
	eor r0, #BROCHE5
	str r0, [r5]
	BX LR
	
LedsOn
	ldr r0, [r5]
	orr r0, #BROCHE4_5
	str r0, [r5]
	BX LR
		
ToggleLeds
	ldr r0, [r5]
	eor r0, #BROCHE4_5
	str r0, [r5]
	BX LR
	
LedsOff
	ldr r0, [r5]
	bic r0, #BROCHE4_5
	str r0, [r5]
	BX LR
		
		nop		
		END
