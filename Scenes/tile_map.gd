extends Node2D

class_name tile_map

@onready var musica = $AudioStreamPlayer2D
var entropuerta=false
# Called when the node enters the scene tree for the first time.
func _ready():
	musica.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cambiarsalaboss()

func _on_puertaboss_body_entered(body):
		if body.has_method("Player"):
			Global.entrosalaboss=true
			entropuerta=true

func cambiarsalaboss():
		if Global.entrosalaboss==true and Global.cont_demonios>2:
			if Global.escenaactual=="tile_map":
				get_tree().change_scene_to_file("res://Scenes/sala_boss.tscn")
				Global.finish_salaboss()
		else:
			if entropuerta==true:
				entropuerta=false
				Global.entrosalaboss=false
				Global.cont_demonios=0
				get_tree().change_scene_to_file("res://Scenes/mundo_alreves.tscn")
				Global.finish_mapaalreves()
