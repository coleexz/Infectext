extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const bullet_scene = preload("res://Scenes/Functions/enemy_projectile.tscn")
@export var time_between_shots = 0.3
@export var spawn_point_count = 5
@export var radius = 50

@export var rotate_speed = 300
@export var direction_change_interval = 3
var rotation_direction = 1
var direction_change_timer = 0

@onready var shoot_timer = $ShootTimer
@onready var rotator = $Rotator

var mode = 0;

func change_pattern():
	mode = randi()%4
	if mode == 0:
		pass
	elif mode == 1:
		pass
	elif mode == 2:
		pass
	elif mode == 3:
		pass

func _ready():
	anim.play("idle")
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var angle = i * (2*PI/spawn_point_count)
		var pos = Vector2(radius*cos(angle),radius*sin(angle))
		spawn_point.position = pos
		spawn_point.rotation = angle 
		rotator.add_child(spawn_point)
		
	shoot_timer.wait_time = time_between_shots
	shoot_timer.start()

func _on_shoot_timer_timeout():
	for r in rotator.get_children():
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.position = r.global_position
		bullet.rotation = r.global_rotation
		
func _physics_process(delta):
	direction_change_timer += delta
	if direction_change_timer >= direction_change_interval:
		direction_change_timer = 0
		rotation_direction*=-1
	
	var new_rotation = rotator.rotation_degrees + rotate_speed * rotation_direction * delta
	rotator.rotation_degrees = fmod(new_rotation,360)
