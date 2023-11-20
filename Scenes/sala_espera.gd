#combio_clases
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():  
	pass

func _process(delta):
	cambiarescena() 


func _on_entrada_laberinto_body_entered(body):

	if body.has_method("Player"):
		Global.cambioescena=true
	
	
func cambiarescena():
		if Global.cambioescena==true:
			if Global.escenaactual=="sala_espera":
				get_tree().change_scene_to_file("res://Scenes/tile_map.tscn")
				Global.finish_changescenes()
				
				
		
		
		
