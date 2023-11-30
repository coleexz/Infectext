extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player_inrange = false
var dialogue_shown = false
@export var player = preload("res://Scenes/Player/player.gd")

func _ready():
	anim.play("idle")

func _physics_process(delta):
	if player_inrange and not dialogue_shown:
		if Input.is_action_just_pressed("ui_accept"):
			if not Global.entro_zonaataque:
				DialogueManager.show_example_dialogue_balloon(load("res://panzon.dialogue"), "panzon")
				dialogue_shown = true
				return
			else:
				_on_enemy_attacking()
		
func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player_inrange = true

func _on_area_2d_body_exited(body):
	if body.has_method("Player"):
		player_inrange = false

# Add this function to handle the enemy's attacking signal
func _on_enemy_attacking():
	if dialogue_shown:
		DialogueManager.dialogue_ended    # Replace with your dialogue hiding logic
		dialogue_shown = false

