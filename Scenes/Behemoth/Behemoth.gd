extends CharacterBody2D

class_name Behemoth

enum States { IDLE, MOVE, ATTACK, DEAD }
var state = States.IDLE

@onready var anim = $AnimatedSprite2D
var speed = 20
var player_chase = false
var player = null
var alive = true
var textito = ""
var textos = ["paracetamol","acetaminofen","cofalpremium","sanasanaculitoderana"]
var death_animation_played = false
var maxHealth = 100
var currentHealth = maxHealth
var in_attack_zone = false
var walk_offset = Vector2(-20, 0)
var original_offset = Vector2(0,0)
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
			anim.offset = original_offset
		States.MOVE:
			anim.play("walk")
			anim.offset = walk_offset
		States.ATTACK:
			var attack_anim = "attack1" if randi() % 2 == 0 else "attack2"
			anim.play(attack_anim)
			anim.offset = original_offset
			player.reduce_health()
		States.DEAD:
			anim.play("death")
			$death_timer.start()

func _physics_process(delta):
	if state == States.DEAD:
		return

	if alive:
		if state == States.ATTACK and not anim.is_playing():
			change_state(States.IDLE)

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

		if player_chase and not in_attack_zone:
			var direction = player.global_position - global_position
			direction = direction.normalized()
			anim.flip_h = direction.x < 0
			global_position += direction * speed * delta
			move_and_collide(direction * speed * delta)
			if state != States.MOVE:
				change_state(States.MOVE)

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true
		body.enable_input_capture(true)
		textito = $RichTextLabel.text
		body.set_text(textito)

func _on_detection_area_body_exited(body):
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
		change_state(States.ATTACK)

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		in_attack_zone = false
		if state == States.ATTACK:
			change_state(States.IDLE)

func _on_death_timer_timeout():
	self.queue_free()
