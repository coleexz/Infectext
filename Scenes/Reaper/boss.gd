extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const bullet_scene = preload("res://Scenes/Functions/enemy_projectile.tscn")
@export var time_between_shots = 0.3
@export var spawn_point_count = 5
@export var radius = 0

@export var rotate_speed = 300
@export var direction_change_interval = 3
var rotation_direction = 1
var direction_change_timer = 0

@onready var shoot_timer = $ShootTimer
@onready var rotator = $Rotator
@onready var mode_timer = $ModeTimer
@onready var idle_timer = $IdleTimer
var mode = 0

var original_offset = Vector2(0, 0)  # Guarda el offset original del sprite
var flipped_offset = Vector2(-65,0)  # Ajusta este valor según necesites


func _ready():
	mode_timer.start()  # Comienza la cuenta regresiva de la duración que elijas
	change_to_idle_mode()

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
		rotation_direction *= -1

	var new_rotation = rotator.rotation_degrees + rotate_speed * rotation_direction * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)
		

func change_to_attack_mode():
	clear_spawn_points()  # Clear previous spawn points
	anim.play("attack")  # Make sure the animation name is correct.
	setup_spawn_points()  # Setup new spawn points for shooting

	idle_timer.stop()
	shoot_timer.wait_time = time_between_shots  # Sets the time between shots.
	shoot_timer.start()  # Start shooting

	# No need to start the mode_timer here as it's started by the idle timeout.

func _on_idle_timer_timeout():
	change_pattern()  # Change the pattern before restarting attack mode.
	change_to_attack_mode()  # Switch back to attack mode.

	mode_timer.start()  # Start the mode_timer here after setting up the attack mode.

func clear_spawn_points():
	for child in rotator.get_children():
		child.queue_free()  # Elimina los puntos de generación actuales

func setup_spawn_points():
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var angle = i * (2 * PI / spawn_point_count)
		var pos = Vector2(radius * cos(angle), radius * sin(angle))
		spawn_point.position = pos
		spawn_point.rotation = angle
		rotator.add_child(spawn_point)

func change_to_idle_mode():
	anim.play("idle")
	shoot_timer.stop()  # Detiene la generación de proyectiles
	mode_timer.stop()  # Detiene el timer de cambio de modo
	idle_timer.start()  # Comienza el contador de inactividad

func _on_mode_timer_timeout():
	change_to_idle_mode()

func change_pattern():
	mode = randi() % 4  # Selecciona un modo al azar entre 0 y 3
	if mode != 3:
		mode_timer.wait_time = 10
		
	if mode == 0:
	# Modo de disparo predeterminado
		spawn_point_count = 3
		rotate_speed = 80
		time_between_shots = 0.2
	elif mode == 1:
		# Modo agresivo, más puntos de disparo y rotación rápida
		spawn_point_count = 6
		rotate_speed = 50
		time_between_shots = 0.2
	elif mode == 2:
		# Modo de disparo rápido y extendido
		spawn_point_count = 10
		rotate_speed = 100
		time_between_shots = 0.5
	elif mode == 3:
		# Modo de disparo único o especial
		spawn_point_count = 16
		rotate_speed = 0
		time_between_shots = 0.15
		mode_timer.wait_time = 4
	print(mode)
