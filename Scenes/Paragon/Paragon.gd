extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var speed = 100
var player_chase = false
var player = null


func _physics_process(delta):
	if player_chase:
		var direction = player.global_position - global_position

		if direction.x < 0: 
			anim.flip_h = true
		else: 
			anim.flip_h = false

		global_position += direction / speed
	else:
		anim.play("idle")



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false

func _on_attack_zone_body_entered(body):
	if body.name == "Player":
		var num = randi()%2
		if num == 0:
			anim.play("attack1")
		else :
			anim.play("attack2")

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		anim.play("move")
