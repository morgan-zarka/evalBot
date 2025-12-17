		AREA    |.text|, CODE, READONLY
		ALIGN

; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO  EQU		0x400FE108 ; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTE_BASE		EQU		0x40024000 ; GPIO Port E (ABP) base : 0x4002.4000 (p291 datasheet de lm3s9b92.pdf)
	
; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN  		EQU 	0x0000051C ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; Pul_up
GPIO_I_PUR  		EQU 	0x00000510 ; GPIO Pull-Up (p432 datasheet de lm3s9B92.pdf)
	
BROCHE_BUMPER0		EQU		0x01		; PE0
BROCHE_BUMPER1		EQU		0x02		; PE1
BROCHES_BUMPER0_1	EQU		0x03		; PE0 | PE1

; Nouvelle adresse pour la lecture groupée
R11_ADDR_BUMPERS	EQU		11          ; Registre R11 pour l'adresse groupée
	
		EXPORT	bumpersInit
		EXPORT	readBumper0
		EXPORT  readBumper1
		EXPORT  readBumpers0_1
			
bumpersInit
		
	ldr r6, = SYSCTL_PERIPH_GPIO 			;; RCGC2
    ldr r0, [r6]                            ; Lecture de l'état actuel (R-M-W)
    orr r0, r0, #0x10 						;; Enable clock sur GPIO E 0x10 = ob010000
	str r0, [r6]
		
	; Délai obligatoire (lecture du registre après activation)
    ldr r0, [r6]                            ; Lecture de RCGC2 pour garantir le délai (Correction)
	nop
	nop
	
	ldr r5, = GPIO_PORTE_BASE		; R5 contient la base du Port E
	ldr r0, = BROCHES_BUMPER0_1		; 0x03 (Masque)
		
		; Pull-Up
	ldr r7, = GPIO_PORTE_BASE+GPIO_I_PUR
	str r0, [r7]
		
		; Digital Enable
	ldr r7, = GPIO_PORTE_BASE+GPIO_O_DEN
	str r0, [r7]
		
		; R9 = Adresse Data Reg. Bumper 0 (PE0)
	ldr r9, = GPIO_PORTE_BASE + (BROCHE_BUMPER0<<2)
		; R10 = Adresse Data Reg. Bumper 1 (PE1)
	ldr r10, = GPIO_PORTE_BASE + (BROCHE_BUMPER1<<2)
    
    ; R11 = Adresse Data Reg. Bumper 0 et 1 (PE0 | PE1)
    ldr r11, = GPIO_PORTE_BASE + (BROCHES_BUMPER0_1<<2)
	
	BX LR
	
readBumper0
	ldr 	r0, [r9]					; Lecture de PE0 (Bumper 0)
	BX LR								

readBumper1
	ldr 	r0, [r10]					; Lecture de PE1 (Bumper 1)
	BX LR

readBumpers0_1
    ldr     r0, [r11]                   ; Lecture de PE0 et PE1 en même temps
    BX LR
	
	END