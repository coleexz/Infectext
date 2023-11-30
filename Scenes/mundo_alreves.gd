extends Node2D
var entropuerta=false

@export var player : Player

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cambiarsalaboss()

func _on_puertaboss_body_entered(body):
	if body.has_method("Player"):
			Global.entrosalaboss=true
			entropuerta=true
			Global.escenaactual="mundo_alreves"
			
func cambiarsalaboss():
		if Global.entrosalaboss==true and Global.cont_demonios==3:
			print("if escenaactualmundoalrevez: ",Global.escenaactual)
			if Global.escenaactual=="mundo_alreves":
				Global.guardarSalud(player.currentHealth)
				get_tree().change_scene_to_file("res://Scenes/sala_boss.tscn")
				Global.finish_salaboss()
		else:
			if entropuerta==true:
				Global.guardarSalud(player.currentHealth)
				print("else escenaactualmundoalrevez: ",Global.escenaactual)
				entropuerta=false
				Global.cont_demonios=0
				get_tree().change_scene_to_file("res://Scenes/tile_map.tscn")
				Global.finish_mapaalreves()
