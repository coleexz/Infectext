extends Node


static var escenaactual="sala_espera"
static var cambioescena=false
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
