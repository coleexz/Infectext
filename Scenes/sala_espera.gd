#combio_clases
extends Node2D
@onready var warning=$Window

# Called when the node enters the scene tree for the first time.
func _ready():  
	warning.popup_centered()
	Global.encenderluz=false;
	
func _process(delta):
	cambiarescena() 


func _on_entrada_laberinto_body_entered(body):
	if body.has_method("Player") and Global.encontrogato==true:
		Global.cambioescena=true
	else:
		warning.popup_centered()	
	
func cambiarescena():
		if Global.cambioescena==true:
			if Global.escenaactual=="sala_espera":
				get_tree().change_scene_to_file("res://Scenes/tile_map.tscn")
				Global.finish_changescenes()
			

func _on_window_close_requested():
	warning.hide()
	
