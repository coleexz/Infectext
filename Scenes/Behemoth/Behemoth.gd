extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 250
var player_chase = false
var player = null

var original_offset = Vector2(0, 0) 
var flipped_offset = Vector2(-65,0) 

func _physics_process(delta):
	if player_chase:
		var direction = player.global_position - global_position

		if direction.x < 0:  # Si el jugador está a la izquierda
			anim.flip_h = true
			anim.offset = flipped_offset  
		else:  # Si el jugador está a la derecha
			anim.flip_h = false
			anim.offset = original_offset  

		global_position += direction / speed
		anim.play("move")
	else:
		anim.play("idle")



func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true


func _on_detection_area_body_exited(body):
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
		body.reduce_health(15)

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		anim.play("walk")

