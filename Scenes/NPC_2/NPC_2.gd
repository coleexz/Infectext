extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player_inrange=false

@export var player = preload("res://Scenes/Player/player.gd")

func _ready():
	anim.play("idle")
	
func _physics_process(delta):
	if player_inrange==true:
		if Input.is_action_just_pressed("ui_accept"):
			
			DialogueManager.show_example_dialogue_balloon(load("res://panzon.dialogue"),"panzon")
			return
	

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player_inrange=true # Replace with function body.


func _on_area_2d_body_exited(body):
	if body.has_method("Player"):
		player_inrange=false
	
