extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 200

static var player_alive = true
var health = 100
var enemy_attack_cooldown = true
var enemy_in_attack_range = false
var bod = ""
@onready var death_timer = $death_timer

func _ready():
	anim.play("idle_down")
	
func _physics_process(delta):
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
	death_timer.start()

func Player():
	pass
	
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown and player_alive: 
		reduce_health(bod)
		print("health = " , health)
		enemy_attack_cooldown = false
		$attack_cooldown.start()

func reduce_health(bod):
	if bod == "Paragon":
		health -= 10
	elif bod == "Behemoth":
		health -= 15
	elif bod == "Beholder":
		health -= 5
	else:
		health -= 20

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_player_hitbox_area_entered(area):
	if area.name == "attack_zone" || area.name == "enemy_projectile":
		enemy_in_attack_range = true

func _on_player_hitbox_area_exited(area):
	if area.name == "attack_zone" || area.name == "enemy_projectile":
		enemy_in_attack_range = false

func _on_player_hitbox_body_entered(body):
	bod = body.name 

func _on_player_hitbox_body_exited(body):
	bod = ""

func _on_death_timer_timeout():
	self.queue_free() 
