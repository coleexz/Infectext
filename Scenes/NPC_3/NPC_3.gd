extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player_inrange=false
@export var player : Player
var dialogue_shown = false

func _ready():
	anim.play("idle")
func _physics_process(delta):
	if player_inrange and not dialogue_shown:
		if Input.is_action_just_pressed("ui_accept"):
			#player.cambiaricononpc("KNIGHT")
			DialogueManager.show_example_dialogue_balloon(load("res://caballero.dialogue"),"caballero")
			dialogue_shown=true
			return
	

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player_inrange=true 


func _on_area_2d_body_exited(body):
	if body.has_method("Player"):
		player_inrange=false


