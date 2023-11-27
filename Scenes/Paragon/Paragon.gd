extends CharacterBody2D

class_name Paragon

signal healthChanged

@onready var anim = $AnimatedSprite2D
var speed = 20
var player_chase = false
var player = null
var alive = true
var death_animation_played = false
var textito = ""
var textos = ["pana"]
var maxHealth = 100
var currentHealth = maxHealth
var in_attack_zone = false
var canattack = true

func _ready():
	seleccionar_texto_aleatorio()
	anim.play("idle")

func seleccionar_texto_aleatorio():
	var texto_aleatorio = textos[randi() % textos.size()]
	$RichTextLabel.text = texto_aleatorio

func _physics_process(delta):
	if alive:
		
		if !canattack and player_chase:
			anim.play("move")
			
		if canattack and in_attack_zone and player != null:
			anim.stop()
			var num = randi() % 2
			if num == 0:
				anim.play("attack1")
			elif num==1:
				anim.play("attack2")
			player.reduce_health()
			canattack = false
			$attack_timer.start()
			anim.play("move")
			
		if player_chase:
			var direction = player.global_position - global_position
			direction=direction.normalized()
			if direction.x < 0:
				anim.flip_h = true
			else:
				anim.flip_h = false
			global_position += direction * speed * delta
			move_and_collide(direction * speed * delta)
		else:
			anim.play("idle")
			
		if player != null and player.get_error():
			seleccionar_texto_aleatorio()
			player.set_error(false)
			textito = $RichTextLabel.text
			player.set_text(textito)
				
		if player != null and player.wrote_good:
			currentHealth = 0
			healthChanged.emit()
			alive = false
			Global.cont_demonios=Global.cont_demonios+1
			print("contdemonios",Global.cont_demonios)
			$Timer.start()
			player.set_wrote_good(false)
			
	elif not death_animation_played:
		player.reset()
		anim.play("death")
		$Timer.start()
		death_animation_played = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true
		body.enable_input_capture(true)
		textito = $RichTextLabel.text
		body.set_text(textito)

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player.reset()
		player = null
		player_chase = false
		body.enable_input_capture(false)
		body.set_text("")
		anim.play("idle")

func _on_attack_zone_body_entered(body):
	if alive and body.name == "Player":
		canattack = true
		in_attack_zone = true
		
func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		canattack = false
		in_attack_zone = false

func _on_timer_timeout():
	self.queue_free()  # Elimina el objeto cuando la animación de muerte termina

func _on_attack_timer_timeout():
	canattack = true
