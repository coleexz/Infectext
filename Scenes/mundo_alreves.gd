extends Node2D
var entropuerta=false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cambiarsalaboss()


func _on_puertaboss_body_entered(body):
	if body.has_method("Player"):
			Global.entrosalaboss=true
			entropuerta=true

func cambiarsalaboss():
		if Global.entrosalaboss==true and Global.cont_demonios==3:
			if Global.escenaactual=="mundo_alreves":
				get_tree().change_scene_to_file("res://Scenes/sala_boss.tscn")
				Global.finish_mapaalreves()
		else:
			if entropuerta==true:
				entropuerta=false
				Global.entrosalaboss=false
				Global.cont_demonios=0
				get_tree().change_scene_to_file("res://Scenes/tile_map.tscn")
				Global.finish_mapaalreves()
