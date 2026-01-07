					AREA    |.text|, CODE, READONLY
DUREE_NORMAL		EQU     0x001FFFFF
DUREE_DOUBLE		EQU		0x00000003
DUREE_DEMITOUR		EQU		0x00000005
DUREE_RAPIDE		EQU		0x000FFFFF
DUREE_RECUL         EQU     0x00A00000  ; AJOUT: Durée longue pour bien reculer
COUNTDOWN			EQU		0x0000000F

			
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
	
		IMPORT  BumpersInit
		IMPORT  ReadBUMPER1
		IMPORT  ReadBUMPER2
		IMPORT  ReadBumpers
	
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

			;;; Registres utilisés : switch : R7 et R8 ;;; bumpers : R9,R10,R11 
			;;; Moteurs : r6 ;;; Leds : R5
			;;; R3 : Vitesse (Durée du délai)
			;;; R12 : Compteur dégressif
			;;; Disponible : R1,R2,R4
__main
	BL LedsInit
	BL SwitchersInit
	BL BumpersInit
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
	
	B crashTest

stop
	BL MOTEUR_DROIT_OFF
	BL MOTEUR_GAUCHE_OFF
	BL LedsOff
	LDR r12, =COUNTDOWN
	LDR r3, =DUREE_NORMAL

	B loop
crashTest
	BL ReadBumpers       
	CMP r0, #0x03
	BNE backup
	B mainLoop

backup
	MOV R2, R0
	BL SetNormalMode
	BL LedsOff
	BL MOTEUR_GAUCHE_ARRIERE
	BL MOTEUR_DROIT_ARRIERE
	
	LDR R1, =DUREE_RECUL    
backupDelay
	SUBS R1, #1
	BNE backupDelay
	
	BL MOTEUR_DROIT_AVANT
	BL MOTEUR_GAUCHE_AVANT

	LDR R3, =DUREE_NORMAL
	LDR R12, =COUNTDOWN
	
	CMP r2, #0x00
	BEQ warningMode
	CMP r2, #0x01
	BEQ turnRight
	CMP r2, #0x02
	BEQ turnLeft

	B mainLoop

turnRight
	BL MOTEUR_GAUCHE_AVANT
	BL MOTEUR_DROIT_ARRIERE
	BL LedsOff
	BL LedOn1
	LDR R1, =DUREE_DOUBLE
	B turnWait

turnLeft
	BL MOTEUR_DROIT_AVANT
	BL MOTEUR_GAUCHE_ARRIERE
	BL LedsOff
	BL LedOn2
	LDR R1, =DUREE_DOUBLE
	B turnWait

turnWait
	BL InitDelay
	
	CMP r2, #0x00
	BLEQ ToggleLeds
	CMP r2, #0x01
	BLEQ ToggleLed1
	CMP r2, #0x02
	BLEQ ToggleLed2

	SUBS R1, #1
	BNE turnWait

	BL MOTEUR_DROIT_AVANT
	BL MOTEUR_GAUCHE_AVANT
	BL LedsOn
	B mainLoop

InitDelay
	PUSH {lr}
	mov r4, r3   
	
delay
	subs r4, #1
	BNE delay
	
	POP {lr}
	BX LR

speedCountdown
	SUBS r12, #1
	BEQ highSpeed
	BX LR

highSpeed
	BL SetRapidMode
	LDR r3, =DUREE_RAPIDE
	B mainLoop
	
warningMode
	BL LedsOff
	BL LedOn2
	BL MOTEUR_GAUCHE_AVANT    
	BL MOTEUR_DROIT_ARRIERE   

	LDR R1, =DUREE_DEMITOUR     
	B turnWait

	END