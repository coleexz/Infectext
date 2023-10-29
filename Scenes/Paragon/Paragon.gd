extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var speed = 250
var player_chase = false
var player = null


func _physics_process(delta):
	if player_chase:
		var direction = player.global_position - global_position

		# Flipear la animación dependiendo de la dirección
		if direction.x < 0:  # Si el jugador está a la izquierda
			anim.flip_h = true
		else:  # Si el jugador está a la derecha
			anim.flip_h = false

		global_position += direction / speed
		anim.play("move")
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
