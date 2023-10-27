extends Node2D

@onready var Player = get_node("player")

func _process(delta):
	# Update the position of this node to match the player's position
	position = Player.position
