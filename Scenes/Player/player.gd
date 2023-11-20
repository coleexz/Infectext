extends CharacterBody2D

class_name Player

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var anim = $AnimatedSprite2D

@export var knockBackPower: int = 800

var speed = 100
var cat_inrange=false
var alreadyspeak=false;
var player_alive = true
var maxHealth = 8
var currentHealth = maxHealth
var enemy_attack_cooldown = true
var enemy_in_attack_range = false
var bod = ""
var input_enabled = false

var my_text = ""
var enemy_text = ""
var input_index = 0
var wrote_good = false
var error = false

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
	anim.play("idle_down")
	$Particles.hide()
	heartsContainer.setMaxHearts(maxHealth)
	
func _physics_process(delta):
	$Particles.play("null")
	if Input.is_action_just_pressed("ui_accept"):
		if alreadyspeak==false:
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"),"Start")
			alreadyspeak=true
			return
	
	
	if player_alive:
		var dir = Input.get_vector("right","left","up","down")
		velocity = dir * speed
		
		var mouse_pos = get_global_mouse_position()
		var dir_to_mouse = mouse_pos - global_position

		if dir == Vector2.ZERO:
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
			die()

func die():
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
	$Particles.show()
	$Particles.play("blood")

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_player_hitbox_area_entered(area):
	if area.name == "attack_zone" || area.name == "enemy_projectile":
		enemy_in_attack_range = true

func _on_player_hitbox_area_exited(area):
	if area.name == "attack_zone" || area.name == "enemy_projectile":
		enemy_in_attack_range = false

func _on_player_hitbox_body_entered(body):
	#entro alguien
	if body.name == "limite" or body.name == "CollisionPolygon2D" or body.name == "NPC_1" or body.name == "NPC_2" or body.name == "NPC_3" or body.name == "cat":
		pass
	else :
		knockBack()
	if body.has_method("Cat"):
		cat_inrange=true
		
	bod = body.name
	
func _on_player_hitbox_body_exited(body):
	#salio alguien
	if body.has_method("Cat"):
		cat_inrange=false
	bod = ""

func set_text(text: String):
	enemy_text = text
	print("texto agarrado: "+enemy_text)
	$CanvasLayer/TEXTO.text = enemy_text
	
func enable_input_capture(enable: bool):
	input_enabled = enable
	
func _input(event):
	if input_enabled and event is InputEventKey:
		if event.pressed and not event.is_echo():
			var key_text = event.as_text()
				
			if key_text not in ["Up", "Down", "Left", "Right", "CapsLock", "Super", "PageDown", "PageUp"]: 
				print(key_text)
				if input_index < enemy_text.length() and key_text == str(enemy_text[input_index]):
					my_text += key_text
					input_index += 1
					print(my_text)
					$Particles.show()
					$Particles.play("good")
				else:
					error = true
					my_text = ""
					input_index = 0
					wrote_good = false
					print("Reinicio debido a entrada incorrecta")
					reduce_health()
					activate_cooldown()
					
				if input_index == enemy_text.length():
					wrote_good=true
					currentHealth=currentHealth+1
					if currentHealth >= maxHealth:
						currentHealth = maxHealth
					heartsContainer.updateHearts(currentHealth)
					
func knockBack():
	var knockBackDirection = ( -velocity.normalized()) * knockBackPower
	velocity = knockBackDirection
	move_and_slide()
	
