extends Node2D

class_name sala_boss

@onready var scream = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.encenderluz=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.reaperalive:
		$CanvasModulate.hide()
