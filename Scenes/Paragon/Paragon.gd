extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 70
var player_chase = false
var player = null
var alive = true
var death_animation_played = false
var textito = ""
var textos = ["HELLO", "GOODBYE", "GOODMORNING"]  # Puedes cambiar estos textos según sea necesario

var original_offset = Vector2(0, 0)
var flipped_offset = Vector2(-65, 0)

func _ready():
	seleccionar_texto_aleatorio()
	anim.play("idle")

func seleccionar_texto_aleatorio():
	var texto_aleatorio = textos[randi() % textos.size()]  # Selecciona un texto al azar
	$RichTextLabel.text = texto_aleatorio  # Asegúrate de tener este nodo en tu escena

func _physics_process(delta):
	if alive:
		if player_chase:
			var direction = player.global_position - global_position
			if direction.x < 0:
				anim.flip_h = true
				anim.offset = flipped_offset
			else:
				anim.flip_h = false
				anim.offset = original_offset
			global_position += direction / speed
			anim.play("move")

		if player != null and player.get_error():
			seleccionar_texto_aleatorio()
			player.set_error(false)
			textito = $RichTextLabel.text
			player.set_text(textito)
				
		if player != null and player.wrote_good:
			alive = false
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
		player = null
		player_chase = false
		seleccionar_texto_aleatorio()
		body.enable_input_capture(false)
		body.set_text("")

func _on_attack_zone_body_entered(body):
	if alive and body.name == "Player":
		var num = randi() % 2
		if num == 0:
			anim.play("attack1")
		else:
			anim.play("attack2")
		body.reduce_health()

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		anim.play("move")

func _on_timer_timeout():
	self.queue_free()  # Elimina el objeto cuando la animación de muerte termina
