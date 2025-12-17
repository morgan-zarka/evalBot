AREA    |.text|, CODE, READONLY
		ALIGN

; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO  EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

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
BROCHE6				EQU 	0x40		; switcher 1
BROCHE7				EQU		0x80		; switcher 2
BROCHE6_7			EQU		0xc0		; switcher 1 et 2
	
		EXPORT	switchersInit
		EXPORT	readSwitch1
		EXPORT  readSwitch2
			
switchersInit
	; ;; Enable the Port D peripheral clock 		(p291 datasheet de lm3s9B96.pdf)									
		ldr r6, =SYSCTL_PERIPH_GPIO 			;; RCGC2
		ldr r0, [r6]                            
        orr r0, r0, #0x08 					    ;; Enable clock sur GPIO D où sont branchés les switchers sans détruire la conf des autres ports des autres
												;; fichiers (c'est un ou binaire)
        str r0, [r6]
		
		nop 								
		nop 
		nop 
	;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION Switcher 1 et 2

		ldr r7, =GPIO_PORTD_BASE+GPIO_I_PUR	    ;; Pul_up 
        ldr r0, =BROCHE6_7		
        str r0, [r7]
		
		ldr r7, =GPIO_PORTD_BASE+GPIO_O_DEN	    ;; Enable Digital Function 
        ldr r0, =BROCHE6_7	
        str r0, [r7]      
		
		ldr r7, =GPIO_PORTD_BASE + (BROCHE6<<2)   ;; @data Register = @base + (mask<<2) ==> Switcher1
		ldr r8, =GPIO_PORTD_BASE + (BROCHE7<<2)   ;; @data Register = @base + (mask<<2) ==> Switcher2
		
	;vvvvvvvvvvvvvvvvvvvvvvvFin configuration Switchers
		BX LR                                    

readSwitch1
		ldr r0, [r7] ;; Résultat stocké dans le registre de retour r0
		BX LR

readSwitch2
		ldr r0, [r8] ;; Résultat stocké dans le registre de retour r0
		BX LR
		
;fin du programme
		NOP
		NOP
		END