extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player_inrange = false
var dialogue_shown = false  # Flag to track whether the dialogue has been shown

func _ready():
	anim.play("idle")

func _physics_process(delta):
	if player_inrange and not dialogue_shown:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://catdialog.dialogue"), "Cat")
			Global.encontrogato = true
			dialogue_shown = true  # Set the flag to true to indicate that the dialogue has been shown
			return

func Cat():
	pass

func _on_area_2d_body_entered(body):
	if body.has_method("Player"):
		player_inrange = true

func _on_area_2d_body_exited(body):
	if body.has_method("Player"):
		player_inrange = false
