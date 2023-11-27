extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_exit_pressed():
	get_tree().quit()
	


func _on_button_pressed():
	Global.cambioescena=false
	Global.escenaactual="sala_espera"
	Global.cont_demonios=0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
