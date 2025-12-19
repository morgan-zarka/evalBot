		AREA    |.text|, CODE, READONLY
DUREE_NORMAL		EQU     0x001FFFFF
DUREE_RAPIDE		EQU			0x000FFFFF
COUNTDOWN				EQU			0x0000000F

			
		ENTRY
		EXPORT	__main
			
		IMPORT  LedsInit
		IMPORT  LedOn1
		IMPORT  ToggleLed1
		IMPORT  LedOn2
		IMPORT  ToggleLed2
		IMPORT  LedsOn
		IMPORT  ToggleLeds
		IMPORT  LedsOff
	
		IMPORT  SwitchersInit
		IMPORT  ReadSwitch1
		IMPORT  ReadSwitch2
	
		IMPORT  bumpersInit
		IMPORT  readBumper0
		IMPORT  readBumper1
		IMPORT  readBumpers0_1
	
		IMPORT  MOTEUR_INIT
		IMPORT  MOTEUR_DROIT_ON
		IMPORT  MOTEUR_DROIT_OFF
		IMPORT  MOTEUR_DROIT_AVANT
		IMPORT  MOTEUR_DROIT_ARRIERE
		IMPORT  MOTEUR_DROIT_INVERSE
		IMPORT  MOTEUR_GAUCHE_ON
		IMPORT  MOTEUR_GAUCHE_OFF
		IMPORT  MOTEUR_GAUCHE_AVANT
		IMPORT  MOTEUR_GAUCHE_ARRIERE
		IMPORT  MOTEUR_GAUCHE_INVERSE
		IMPORT  SetRapidMode
		IMPORT  SetNormalMode

			;;; Registres utilis�s : switch : R7 et R8 ;;; bumpers : R1,R2,R9,R10,R11 ;;; Moteurs : r6 ;;; Leds : R5;;; R3 et R12 Pour des flags de durée
			;;; Registre DISPONIBLE : R4
__main
	BL LedsInit
	BL SwitchersInit
	BL bumpersInit
	BL MOTEUR_INIT	

	LDR r12, =COUNTDOWN
	LDR R3, =DUREE_NORMAL

loop
	BL ReadSwitch1
	CMP r0, #0x000
	BEQ start
	B loop
	
start
	BL MOTEUR_DROIT_ON
	BL MOTEUR_GAUCHE_ON	
	BL MOTEUR_DROIT_AVANT	   
	BL MOTEUR_GAUCHE_AVANT
	BL SetNormalMode
	B mainLoop
	
mainLoop
	BL ToggleLeds
	
	CMP r12, #0x000
	BLGT speedCountdown

	BL InitDelay

	BL ReadSwitch2
	CMP r0, #0x000
	BEQ stop

	B mainLoop

stop
	BL MOTEUR_DROIT_OFF
	BL MOTEUR_GAUCHE_OFF
	BL LedsOff
	LDR r12, =COUNTDOWN
	LDR r3, =DUREE_NORMAL

	B loop
	
InitDelay
	mov r4, r3
	
delay
	subs r4, #1
	BNE delay
	
	BX LR

speedCountdown
	SUBS r12, #1
	BEQ highSpeed
	BX LR

highSpeed
	BL SetRapidMode
	LDR r3, =DUREE_RAPIDE
	B mainLoop
	
	
	END
	