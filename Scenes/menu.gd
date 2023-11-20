extends Control

class_name menu

@export var play: Play

@onready var waitingscreenmusic = $AudioStreamPlayer

func _ready():
	waitingscreenmusic.play()
	
func stop_music():
	waitingscreenmusic.stop()
	
func _process(delta):
	pass
