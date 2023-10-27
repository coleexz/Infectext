extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var player = get_node("Player")

func _ready():
	anim.play("run")
