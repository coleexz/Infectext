extends Node

var sal = 8
var encontrogato=false
signal encontrogato_cambiado
var escenaactual="sala_espera"
var cambioescena=false
var entrosalaboss=false
var cont_demonios=0
var encenderluz=false;
#donde comienza
var playerstart_x=0
var playerstart_y=0
#donde sale
var playerexit_x=0
var playerexit_y=0
var entro_zonaataque=false
var reaperalive = true
var playeralive = true

func _process(delta):
	if !playeralive:
		sal = 8
		
func getReaperAlive():
	return reaperalive 
	
func guardarSalud(saludJugador):
	sal = saludJugador

func ponerSalud() -> int:
	return sal
	
func finish_changescenes():
	if cambioescena==true:
		cambioescena=false
		if escenaactual=="sala_espera":
			escenaactual="tile_map"
		else:
			escenaactual="tile_map"
			
func finish_salaboss():
	print("salabosscontdemon: ",cont_demonios)
	if entrosalaboss==true and cont_demonios>2:
		entrosalaboss=false
		if escenaactual=="tile_map":
			escenaactual="sala_boss"
		else:
			escenaactual="sala_boss"
			
func finish_mapaalreves():
	if cont_demonios>2:
		if escenaactual=="tile_map":
			escenaactual="mundo_alreves"
		else:
			escenaactual="tile_map"
