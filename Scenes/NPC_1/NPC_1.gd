extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player : Player

func _ready():
	anim.play("idle")
