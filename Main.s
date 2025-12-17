		AREA    |.text|, CODE, READONLY
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
			
        IMPORT  switchersInit
        IMPORT  readSwitch1
        IMPORT  readSwitch2
			
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
			;;; Registres utilisés : switch : R7 et R8 ;;; bumpers : R9,R10,R11 ;;; Moteurs : r6 ;;; Leds : R5
			;;; Registre DISPONIBLE : R1,R2,R3,R4,R12
__main
	BL LedsInit
	BL switchersInit
	BL bumpersInit
	BL MOTEUR_INIT
	
	END
	