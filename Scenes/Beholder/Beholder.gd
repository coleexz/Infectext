extends CharacterBody2D

class_name Beholder

@onready var anim = $AnimatedSprite2D
var speed = 250
var player_chase = false
var player = null
var textito = ""
var bod = ""

var maxHealth = 100
var currentHealth = maxHealth

var textos = ["HELLO","GOODBYE","GOODMORNING"]  # Arreglo con posibles textos

var original_offset = Vector2(0, 0)
var flipped_offset = Vector2(-30,0)

signal healthChanged

func _ready():
	seleccionar_texto_aleatorio()

func seleccionar_texto_aleatorio():
	var texto_aleatorio = textos[randi() % textos.size()]  # Selecciona un texto al azar
	$RichTextLabel.text = texto_aleatorio
	
func _physics_process(delta):
	if player !=null and player.get_error():
		seleccionar_texto_aleatorio()
		player.set_error(false)
		textito = $RichTextLabel.text
		player.set_text(textito)
		
	if player != null and player.wrote_good:
		currentHealth = 0
		healthChanged.emit()
		anim.play("death")
		$Timer.start()
		player.set_wrote_good(false)
		
	if player_chase:
		var direction = player.global_position - global_position
		
		if direction.x < 0:  # Si el jugador está a la izquierda
			anim.flip_h = true
			anim.offset = flipped_offset
		else:  # Si el jugador está a la derecha
			anim.flip_h = false
			anim.offset = original_offset

		global_position += direction / speed
	
	else:
		anim.play("fly")
		
func _on_watch_zone_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true
		body.enable_input_capture(true)
		textito = $RichTextLabel.text
		body.set_text(textito)

func _on_watch_zone_body_exited(body):
	if body.name == "Player":
		player.reset()
		player = null
		player_chase = false
		seleccionar_texto_aleatorio() 
		body.enable_input_capture(false)
		body.set_text("")
		
func _on_attack_zone_body_entered(body):
	if body.name == "Player":
		body.reduce_health()
		anim.play("attack")

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		anim.play("fly")

func _on_timer_timeout():
	self.queue_free()
