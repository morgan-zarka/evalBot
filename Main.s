		AREA    |.text|, CODE, READONLY
		ENTRY
		EXPORT	__main
			
		IMPORT  ledsInit
        IMPORT  ledOn1
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
        IMPORT  readBumper0_1
			
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
