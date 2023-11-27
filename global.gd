extends Node

var encontrogato=false
signal encontrogato_cambiado
var escenaactual="sala_espera"
var cambioescena=false
var entrosalaboss=false
var cont_demonios=0
#donde comienza
var playerstart_x=0
var playerstart_y=0
#donde sale
var playerexit_x=0
var playerexit_y=0

func finish_changescenes():
	if cambioescena==true:
		cambioescena=false
		if escenaactual=="sala_espera":
			escenaactual="tile_map"
		else:
			escenaactual="tile_map"
			
func finish_salaboss():
	print("entro",cont_demonios)
	if entrosalaboss==true and cont_demonios==3:
		entrosalaboss=false
		cont_demonios=0
		if escenaactual=="tile_map":
			escenaactual="sala_boss"
		else:
			escenaactual="sala_boss"
		if escenaactual=="mundo_alreves":
			escenaactual="sala_boss"
		else:
			escenaactual="sala_boss"					
	
				
func finish_mapaalreves():
	if entrosalaboss==true and cont_demonios==3:
		cont_demonios=0
		entrosalaboss=false
		if escenaactual=="tile_map":
			escenaactual="mundo_alreves"
		else:
			escenaactual="tile_map"
	
