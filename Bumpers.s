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
	
BROCHE_BUMPER1		EQU		0x01		; PE0
BROCHE_BUMPER2		EQU		0x02		; PE1
BROCHES_BUMPER1_2	EQU		0x03		; PE0 | PE1

; Nouvelle adresse pour la lecture group�e
R11_ADDR_BUMPERS	EQU		11          ; Registre R11 pour l'adresse group�e
	
		EXPORT	BumpersInit
		EXPORT	ReadBUMPER1
		EXPORT  ReadBUMPER2
		EXPORT  ReadBumpers
			
BumpersInit
    
    ldr r6, = SYSCTL_PERIPH_GPIO 
    ldr r0, [r6]                   
    orr r0, r0, #0x10 
    str r0, [r6]
        
    nop
    nop
    nop

    ldr r1, = GPIO_PORTE_BASE      
    ldr r0, = BROCHES_BUMPER1_2
        
    ; Pull-Up
    ldr r2, = GPIO_PORTE_BASE+GPIO_I_PUR
    str r0, [r2]
        
    ; Digital Enable
    ldr r2, = GPIO_PORTE_BASE+GPIO_O_DEN
    str r0, [r2]
        
    ldr r9, = GPIO_PORTE_BASE + (BROCHE_BUMPER1<<2)
    ldr r10, = GPIO_PORTE_BASE + (BROCHE_BUMPER2<<2)
    ldr r11, = GPIO_PORTE_BASE + (BROCHES_BUMPER1_2<<2)
    
    BX LR
	
ReadBUMPER1
	ldr 	r0, [r9]					; Lecture de PE0 (Bumper 0)
	BX 	LR								

ReadBUMPER2
	ldr 	r0, [r10]					; Lecture de PE1 (Bumper 1)
	BX LR

ReadBumpers
    ldr     r0, [r11]                   ; Lecture de PE0 et PE1 en m�me temps
    BX LR
	
	END