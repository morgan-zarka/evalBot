##### **Team 1 - DumbSpirator: Mohamed FARAH ; Morgan ZARKA**



###### **Fonctionnement**



On active le robot avec le switch 1



Il avance continuellement jusqu'à rencontrer un obstacle.



 	Cas 1 :  L'obstacle touche le bumper gauche.

 		Le robot fait clignoter la led droite.

 		Le robot recule d'une certaine distance

 		Le robot Pivote du côté droit et continue sa route



 	Cas 2 : L'obstacle touche le bumper droit.

 		Le robot fait clignoter la led gauche.

 		Le robot recule d'une certaine distance

 		Le robot Pivote du côté gauche et continue sa route



 	Cas 3 : L'obstacle touche les deux bumper.

 		Le robot allume les feux de détresse(gauche droit clignotent en alternance).

 		Le robot fait un demi tour

 		Le robot éteint les feux de détresses.

 		Le robot continue sa route.



Particularité :



Au bout d'un certain temps sans touche d'obstacle, le robot va accélérer et faire clignoter très rapidement ses leds.

Lorsqu'il est en mode vitesse normal, les leds clignotent lentement

On éteint le robot avec le switch 2





boucle btn1 // Mohamed -allumage -> DONE



faire avancer // Morgan -> DONE



boucle bumpers (Mohamed) (test bumper) -> DONE + btn2 (Morgan) -> DONE + clignotement passif (Mohamed) -> DONE + augmentation vitesse (horloge à gérer) (Morgan) -> DONE

Si bumpers, vérifier si juste 1 ou si les deux



faire reculer (Mohamed) -> DONE + Pivoter (Morgan) -> DONE + reset horloge (Morgan) -> DONE + clignotant (Morgan) -> DONE



Mode détresse :

Faire reculer (Morgan) -> DONE

Demi tour (Mohamed) -> DONE

Lumière alternance (Morgan) -> DONE

