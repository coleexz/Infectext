extends CanvasLayer
@onready var waitingscreenmusic = $AudioStreamPlayer

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_pressed():
	Global.cambioescena=false
	Global.escenaactual="sala_espera"
	Global.cont_demonios=0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_exit_pressed():
	get_tree().quit()
