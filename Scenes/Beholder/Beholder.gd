extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 250
var player_chase = false
var player = null

var original_offset = Vector2(0, 0)  # Guarda el offset original del sprite
var flipped_offset = Vector2(-30,0)  # Ajusta este valor según necesites

func _physics_process(delta):
	if player_chase:
		var direction = player.global_position - global_position

		# Flipear la animación dependiendo de la dirección
		if direction.x < 0:  # Si el jugador está a la izquierda
			anim.flip_h = true
			anim.offset = flipped_offset  # Ajusta el offset cuando el sprite es "flipeado"
		else:  # Si el jugador está a la derecha
			anim.flip_h = false
			anim.offset = original_offset  # Vuelve al offset original

		global_position += direction / speed
	
	else:
		anim.play("fly")
		
func _on_watch_zone_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true


func _on_watch_zone_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false
		
func _on_attack_zone_body_entered(body):
	if body.name == "Player":
		anim.play("attack")

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		anim.play("fly")