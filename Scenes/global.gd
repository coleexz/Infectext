extends Node

var encontrogato=false
signal encontrogato_cambiado
var escenaactual="sala_espera"
var cambioescena=false
var entrosalaboss=false

#donde comienza
var playerstart_x=0
var playerstart_y=0
#donde sale
var playerexit_x=0
var playerexit_y=0

func finish_changescenes():
	if cambioescena==true:
		if encontrogato==true:
			cambioescena=false
			if escenaactual=="sala_espera":
				escenaactual="tile_map"
			else:
				escenaactual="tile_map"
		else:
			print("no ha interactuado con el gato")
			
