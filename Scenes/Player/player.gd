extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 120
var cat_inrange=false
var alreadyspeak=false;
var player_alive = true
var health = 100
var enemy_attack_cooldown = true
var enemy_in_attack_range = false
var bod = ""
var input_enabled = false

var my_text = ""
var enemy_text = ""
var input_index = 0
var wrote_good = false
var error = false

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
	
func _physics_process(delta):
	
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
		
		if health<=0:
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

func reduce_health(h: int):
	health -=h
	print(health)

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
	if body.has_method("Cat"):
		cat_inrange=true
		
	bod = body.name
	print(bod)
	
func _on_player_hitbox_body_exited(body):
	#salio alguien
	if body.has_method("Cat"):
		cat_inrange=false
	bod = ""

func set_text(text: String):
	enemy_text = text
	print("texto agarrado: "+enemy_text)
	
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
				else:
					error = true
					my_text = ""
					input_index = 0
					wrote_good = false
					print("Reinicio debido a entrada incorrecta")
					reduce_health(20)
					activate_cooldown()
					
				if input_index == enemy_text.length():
					wrote_good=true
					
