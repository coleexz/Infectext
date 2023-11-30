extends CharacterBody2D

class_name Beholder

@onready var anim = $AnimatedSprite2D
var speed = 20
var alive = true
var player_chase = false
var player = null
var textito = ""
var bod = ""
var canattack = true
var maxHealth = 100
var currentHealth = maxHealth
var in_attack_zone = false

var textos = ["hola"]#"AMOXICILINA","LANSOPRAZOL","FUROSEMIDA"]  # Arreglo con posibles textos

var original_offset = Vector2(0, 0)
var flipped_offset = Vector2(-30,0)

signal healthChanged

func _ready():
	seleccionar_texto_aleatorio()

func seleccionar_texto_aleatorio():
	var texto_aleatorio = textos[randi() % textos.size()]  # Selecciona un texto al azar
	$RichTextLabel.text = texto_aleatorio
	
func _physics_process(delta):
	
	if in_attack_zone and canattack and player!=null:
		player.reduce_health()
		anim.play("attack")
		$attack_timer.start()
		canattack = false
		Global.entro_zonaataque=true
		
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
		Global.cont_demonios=Global.cont_demonios+1
		print("contdemonios",Global.cont_demonios)
	if player_chase and alive:
		var direction = player.global_position - global_position
		direction = direction.normalized() 
		if direction.x < 0:  # Si el jugador está a la izquierda
			anim.flip_h = true
			anim.offset = flipped_offset
		else:  # Si el jugador está a la derecha
			anim.flip_h = false
			anim.offset = original_offset

		global_position += direction * speed * delta 
		move_and_collide(direction * speed * delta)  	
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
		in_attack_zone = true

func _on_attack_zone_body_exited(body):
	if body.name == "Player":
		in_attack_zone = false
		anim.play("fly")
		
func _on_timer_timeout():
	alive = false
	self.queue_free()

func _on_attack_timer_timeout():
	canattack = true
	print("ya puede atacar")
