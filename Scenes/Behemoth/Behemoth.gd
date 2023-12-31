extends CharacterBody2D

class_name Behemoth

enum States {IDLE, MOVE, ATTACK, DEAD}
var state = States.IDLE

@onready var anim = $AnimatedSprite2D
var canattack = true
var speed = 20
var player_chase = false
var player = null
var alive = true
var textito = ""
var textos = ["pala"]
var death_animation_played = false
var maxHealth = 100
var currentHealth = maxHealth
var in_attack_zone = false
signal healthChanged

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
			anim.play("walk")
		States.ATTACK:
			var attack_anim = "attack1" if randi() % 2 == 0 else "attack2"
			anim.play(attack_anim)
			if player != null:
				player.reduce_health()
			canattack = false  # Disable further attacks
			$attack_timer.start()  # Start the attack cooldown timer
		States.DEAD:
			if not death_animation_played:
				anim.play("death")
				$death_timer.start()
				death_animation_played = true

func _physics_process(delta):
	if not alive:
		if not death_animation_played:
			change_state(States.DEAD)
		return
		
		if currentHealth <= 0 and alive:
			alive = false
			change_state(States.DEAD)

	if alive:
		if state == States.ATTACK and not anim.is_playing():
			change_state(States.IDLE)
			canattack = false

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
				Global.cont_demonios += 1
				player.set_wrote_good(false)
				player.cantype(false)

		if player_chase and not in_attack_zone and state!=States.DEAD:
			var direction = player.global_position - global_position
			direction = direction.normalized()
			anim.flip_h = direction.x < 0
			global_position += direction * speed * delta
			move_and_collide(direction * speed * delta)
			if state != States.MOVE:
				change_state(States.MOVE)

func _on_detection_area_body_entered(body):
	if body.name == "Player" and alive:
		player = body
		player_chase = true
		body.enable_input_capture(true)
		textito = $RichTextLabel.text
		body.set_text(textito)

func _on_detection_area_body_exited(body):
	if body.name == "Player" and alive:
		player.reset()
		player = null
		player_chase = false
		body.enable_input_capture(false)
		body.set_text("")
		change_state(States.IDLE)

func _on_attack_zone_body_entered(body):
	if alive and body.name == "Player" and canattack:
		in_attack_zone = true
		change_state(States.ATTACK)

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		in_attack_zone = false
		if state == States.ATTACK and alive:
			change_state(States.IDLE)

func _on_attack_timer_timeout():
	canattack = true


func _on_death_timer_timeout():
	self.queue_free()
