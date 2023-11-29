extends CharacterBody2D

class_name Paragon

enum States { IDLE, MOVE, ATTACK, DEAD }
var state = States.IDLE

signal healthChanged

@onready var anim = $AnimatedSprite2D
var player_chase = false
var speed = 20
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
	change_state(States.IDLE)

func seleccionar_texto_aleatorio():
	var texto_aleatorio = textos[randi() % textos.size()]
	$RichTextLabel.text = texto_aleatorio

func change_state(new_state):
	state = new_state
	match state:
		States.IDLE:
			anim.play("idle")
		States.MOVE:
			anim.play("move")
		States.ATTACK:
			var attack_anim = "attack1" if randi() % 2 == 0 else "attack2"
			anim.play(attack_anim)
			player.reduce_health()
		States.DEAD:
			anim.play("death")
			if not death_animation_played:
				death_animation_played = true
				$Timer.start()

func _physics_process(delta):
	if state == States.DEAD:
		return

	if alive:
		# Verificar si el estado de ataque ha terminado
		if state == States.ATTACK and not anim.is_playing():
			change_state(States.MOVE)

		# Interacciones con el jugador
		if player != null:
			if player.get_error():
				seleccionar_texto_aleatorio()
				player.set_error(false)
				textito = $RichTextLabel.text
				player.set_text(textito)
			elif player.wrote_good:
				currentHealth = 0
				healthChanged.emit()
				alive = false
				change_state(States.DEAD)
				Global.cont_demonios += 1
				player.set_wrote_good(false)

		# Manejar movimiento y ataque
		if player_chase:
			var direction = player.global_position - global_position
			direction = direction.normalized()
			anim.flip_h = direction.x < 0
			if state != States.ATTACK:
				change_state(States.MOVE)
			global_position += direction * speed * delta
			move_and_collide(direction * speed * delta)

		# Iniciar ataque si es posible
		if canattack and in_attack_zone and state != States.ATTACK and player != null:
			change_state(States.ATTACK)
			canattack = false
			$attack_timer.start()
	else:
		change_state(States.DEAD)


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
		change_state(States.IDLE)

func _on_attack_zone_body_entered(body):
	if alive and body.name == "Player":
		in_attack_zone = true
		if canattack:
			change_state(States.ATTACK)

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		in_attack_zone = false
		if state == States.ATTACK:
			change_state(States.IDLE)

func _on_timer_timeout():
	self.queue_free() 

func _on_attack_timer_timeout():
	canattack = true
