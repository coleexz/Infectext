extends Node2D

@onready var scream = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	scream.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
