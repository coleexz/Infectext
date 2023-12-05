extends CharacterBody2D

class_name Player


@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var anim = $AnimatedSprite2D
@onready var err = $err
@onready var key = $key
@onready var powerup = $powerup
@onready var hpup = $hpup

@onready var timer := $PointLight2D/light_Timer
@onready var light := $PointLight2D

static var kingprofile = preload("res://Assets/Mobs/NPC/perfil/king.png")
static var captainprofile = preload("res://Assets/Mobs/NPC/perfil/captain.png")
static var panzonprofile = preload("res://Assets/Mobs/NPC/perfil/merchant.png")
static var playerprofile = preload("res://Assets/Mobs/NPC/perfil/player.png")
static var catprofile = preload("res://Assets/Mobs/NPC/perfil/cat.png")

@export var knockBackPower: int = 200
var salaboss=false;
var walking = false
var puedeescribir = false
var error_timer_active = false
var moving = false
var anim_speed = 1200
var speed = 100
var cat_inrange=false
var alreadyspeak=false;
var player_alive = true
var maxHealth = 8
var currentHealth = 8
var enemy_attack_cooldown = true
var enemy_in_attack_range = false
static var bod = ""
var input_enabled = false
var my_text = ""
var enemy_text = ""
var input_index = 0
var wrote_good = false
var error = false
var target_zoom = Vector2(3,3)  # Zoom objetivo cuando se recoge la poción
var original_zoom = Vector2(4.5, 4.5)
var zoom_speed = 0.01 # Velocidad a la que cambia el zoom
	
func cantype(value: bool):
	input_enabled = value
	
func incrementSpeed():
	speed = 300
	
func cambiaricononpc():
	pass
		
func reset():
	$CanvasLayer/TEXTO.text = ""
	my_text = ""
	enemy_text = ""
	input_index = 0
	wrote_good = false
	error = false
	
func get_player_alive():
	return player_alive
	
func get_error():
	return error
	
func set_error(boolean :bool):
	error = boolean
	
func get_text_player():
	return my_text
	
func set_wrote_good(enable: bool):
	wrote_good = enable
	
func get_wrote_good():
	return wrote_good
	
func _ready():
	heartsContainer.setMaxHearts(maxHealth)
	currentHealth = Global.sal
	anim.play("idle_down")
	$Particles.hide()
	heartsContainer.updateHearts(currentHealth)
	hiiide()
	randomize()
	
func _physics_process(delta):
	salaboss=true;
	$Particles.play("null")
	
	if Input.is_action_just_pressed("ui_accept"):
		if alreadyspeak==false:
			DialogueManager.show_example_dialogue_balloon(load("res://main2.dialogue"),"Start")
			bod = "PLAYER"
			alreadyspeak=true
			return
	
	
	if player_alive:
		var dir = Input.get_vector("right","left","up","down")
		velocity = dir * speed
		
		var mouse_pos = get_global_mouse_position()
		var dir_to_mouse = mouse_pos - global_position
		print("")
		
# Comprobar si el personaje se está moviendo
		if dir != Vector2.ZERO:
			if not walking:
				$playerwalk.play()
				walking = true
			elif !$playerwalk.playing:  # Si el personaje sigue moviéndose pero el sonido terminó
				$playerwalk.play()  # Reiniciar la reproducción del sonido
		elif walking:
			$playerwalk.stop()
			walking = false
			
		if dir == Vector2.ZERO:
			walking = false
			if dir_to_mouse.y > 0:
				anim.play("idle_down")
			elif dir_to_mouse.y < 0:
				anim.play("idle_up")
		else:
			if dir.x > 0:
				anim.play("walk_right")
				anim.flip_h = false
			elif dir.x < 0:
				anim.play("walk_right")
				anim.flip_h = true
			elif dir.y > 0:
				anim.play("walk_down")
			elif dir.y < 0:
				anim.play("walk_up")

		move_and_slide()
		enemy_attack()
		
		if currentHealth<=0:
			$death_timer.start()
			player_alive = false
		
		if input_enabled == false:
			hide_canvas(delta)
			
		if input_enabled == true:
			show_canvas(delta)
	else:
		anim.play("death")
		if(!anim.is_playing()):
			anim.stop()
			
func increaseHealth():
	currentHealth = currentHealth + 1
	if currentHealth >= maxHealth:
		currentHealth = maxHealth
	heartsContainer.updateHearts(currentHealth)
	
	
func hiiide():
	$CanvasLayer/TEXTO.position.y = 1500
	$CanvasLayer/Sprite2D.position.y = 1500
	
func hide_canvas(delta):
	var current_y_sprite2d = $CanvasLayer/Sprite2D.position.y
	var current_y_texto = $CanvasLayer/TEXTO.position.y
	
	if current_y_sprite2d < 1500 and current_y_texto < 1500:
		$CanvasLayer/Sprite2D.position.y += anim_speed * delta
		$CanvasLayer/TEXTO.position.y += anim_speed * delta

# Función para mostrar el canvas
func show_canvas(delta):
	var current_y_sprite2d = $CanvasLayer/Sprite2D.position.y
	var current_y_texto = $CanvasLayer/TEXTO.position.y
	if current_y_sprite2d > 961:
		$CanvasLayer/Sprite2D.position.y -= anim_speed * delta
	if current_y_texto > 925:
		$CanvasLayer/TEXTO.position.y -= anim_speed * delta
	else:
		pass
	
func die():
	get_tree().change_scene_to_file("res://game_over_sceen.tscn")
	Global.playeralive = false
	$deathh.play()
	player_alive = false
	anim.play("death")
	enable_input_capture(false)

func Player():
	pass
	
func check_cooldown() -> bool:
	return !$attack_cooldown.is_stopped()
	
func activate_cooldown():
	$attack_cooldown.start()
	enemy_attack_cooldown = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown and player_alive:
		enemy_attack_cooldown = false
		activate_cooldown()

func reduce_health():
	currentHealth -=1
	heartsContainer.updateHearts(currentHealth)
	$Particles.play("blood")

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_player_hitbox_area_entered(area):
	if area.name == "hoyo":
		player_alive = false
		$AnimatedSprite2D.hide()
		$falltimer.start()
		
	if area.name == "attack_zone":
		$alerted.play()
	if area.name == "attack_zone" || area.name == "enemy_projectile":
		enemy_in_attack_range = true
	if area.name == "pocion_salud":
		increaseHealth()
		hpup.play()
	if area.name == "pocion_velocidad":
		incrementSpeed()
		powerup.play()
		target_zoom = Vector2(2.5,2.5)  # Establece el zoom objetivo
		$Timer.start()  # Inicia el temporizador para la interpolación del zoom
		$speedTimer.start()
	if area.name == "Puertaboss":
		Global.guardarSalud(currentHealth)
		
func _on_player_hitbox_area_exited(area):
	if area.name == "attack_zone" || area.name == "enemy_projectile":
		enemy_in_attack_range = false

func _on_player_hitbox_body_entered(body):
	#entro alguien		
	if body.name == "NPC_1":
		cambiaricononpc()
		bod = "KING"
	elif body.name == "NPC_2":
		cambiaricononpc()
		bod = "PANZON"
	elif body.name == "NPC_3":
		cambiaricononpc()
		bod = "KNIGHT"
	
	
	if body.has_method("Cat"):
		cambiaricononpc()
		cat_inrange=true
		
	bod = body.name
	
func _on_player_hitbox_body_exited(body):
	#salio alguien
	if body.has_method("Cat"):
		cambiaricononpc()
		cat_inrange=false
	bod = ""
	
	cambiaricononpc()

func set_text(text: String):
	if !error_timer_active:
		puedeescribir = true
		enemy_text = text
		print("texto agarrado: "+enemy_text)
		$CanvasLayer/TEXTO.text = "[center]"+enemy_text+"[/center]"
	
func enable_input_capture(enable: bool):
	input_enabled = enable
	
func _input(event):
	if input_enabled and event is InputEventKey:
		if event.pressed and not event.is_echo() and puedeescribir:
			var key_text = event.as_text()
			key_text = key_text.to_lower()
				
			if key_text not in ["up", "down", "left", "right", "capslock", "super", "pagedown", "pageup"]:
				if input_index < enemy_text.length() and key_text == str(enemy_text[input_index]):
					my_text += key_text
					input_index += 1
					var typed_text = enemy_text.substr(0, input_index)
					var remaining_text = enemy_text.substr(input_index, enemy_text.length() - input_index)
					$CanvasLayer/TEXTO.bbcode_text = "[center][color=green]" + typed_text + "[/color]" + remaining_text +"[/center]"
					$Particles.show()
					$Particles.play("good")
					key.play()
				else:
					if currentHealth != 0:
						err.play()
					error = true
					my_text = ""
					input_index = 0
					wrote_good = false
					puedeescribir = false
					$CanvasLayer/TEXTO.bbcode_text = "[center][color=red]" + enemy_text + "[/color][/center]"
					error_timer_active = true  # Desactivar entrada de texto
					$errorTImer.start()  # Iniciar el timer
					reduce_health()
					activate_cooldown()
							
				if input_index == enemy_text.length():
					wrote_good=true
					$good.play()
					currentHealth=currentHealth+1
					if currentHealth >= maxHealth:
						currentHealth = maxHealth
					heartsContainer.updateHearts(currentHealth)

func _on_speed_timer_timeout():
	speed = 100  # Restablecer la velocidad
	target_zoom = original_zoom  # Establecer el zoom objetivo
	$Timer.start()
	
func _on_error_t_imer_timeout():
	puedeescribir = true
	error_timer_active = false  # Reactivar entrada de texto
	$CanvasLayer/TEXTO.bbcode_text = "[center][color=white]" + enemy_text + "[/color][/center]"


func _on_light_timer_timeout():
#if Global.encenderluz==true:
	var rand_amt := (randf())
	light.energy = rand_amt
	timer.start(rand_amt/20)


func _on_timer_timeout():
	var current_zoom = $Camera2D.zoom
	current_zoom = current_zoom.lerp(target_zoom, zoom_speed)
	$Camera2D.zoom = current_zoom

	# Comprobar si se ha alcanzado el zoom objetivo
	if current_zoom.distance_to(target_zoom) < 0.01:
		$Camera2D.zoom = target_zoom  # Establecer el valor exacto
		$Timer.stop()  # Detener el temporizador


func _on_falltimer_timeout():
	die()


func _on_death_timer_timeout():
	die()
	
