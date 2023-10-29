extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 150

var player_alive = true
var health = 100
var enemy_attack_cooldown = true
var enemy_in_attack_range = false 


func _ready():
	anim.play("idle_down")
	
func _physics_process(delta):
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
	
	if health==0:
		player_alive = false
		health = 0
		self.queue_free()
		
		
func enemy_attack():
	if enemy_in_attack_range==true and enemy_attack_cooldown==true: 
		health = health - 10
		print(health)
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		
func _on_player_hitbox_body_entered(body):
	enemy_in_attack_range = true
	
func _on_player_hitbox_body_exited(body):
	enemy_in_attack_range = false

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
