extends CharacterBody2D

class_name Reaper

signal healthChanged

@onready var musica = $AudioStreamPlayer2D
@onready var anim = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var rotator = $Rotator
@onready var mode_timer = $ModeTimer
@onready var idle_timer = $IdleTimer
@onready var death_timer = $DeathTimer
var player

const bullet_scene = preload("res://Scenes/Functions/enemy_projectile.tscn")
const cura=preload("res://Scenes/cura.tscn")

@export var attack_speed = 15
@export var idle_speed = 60
@export var time_between_shots = 0.3
@export var spawn_point_count = 5
@export var radius = 0
@export var rotate_speed = 300
@export var direction_change_interval = 3

var current_speed = idle_speed
var rotation_direction = 1
var direction_change_timer = 0
var mode = 0

var maxHealth = 300
var currentHealth = maxHealth

var hurt_offset = Vector2(-37, 0)  # Ajusta este valor según sea necesario
var normal_offset = Vector2(0, 0)

var textos = [
	"hola"
]

var textito = ""

func _ready():
	change_to_idle_mode()
	mode_timer.start()
	seleccionar_texto_aleatorio()
	musica.play()
	$grito.play()

func seleccionar_texto_aleatorio():
	textito = textos[randi() % textos.size()]
	$RichTextLabel.text = textito
	
func _on_shoot_timer_timeout():
	for r in rotator.get_children():
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.position = r.global_position
		bullet.rotation = r.global_rotation

func _physics_process(delta):
		
	if currentHealth <= 0:
		death()
		currentHealth = 0
		Global.cambioescena=false
		Global.escenaactual="sala_espera"
		
		
		
	if player !=null and player.get_error():
		seleccionar_texto_aleatorio()
		player.set_error(false)
		textito = $RichTextLabel.text
		player.set_text(textito)
				
	if player != null and player.wrote_good:
		player.reset()
		currentHealth-=100
		healthChanged.emit()
		change_to_null_mode()
		player.set_wrote_good(false)
				
	if player != null:
		if player.get_player_alive():
			var direction = (player.global_position - global_position).normalized()
			position += direction * current_speed * delta

				# Rotación y cambio de dirección
			direction_change_timer += delta
			if direction_change_timer >= direction_change_interval:
				direction_change_timer = 0
				rotation_direction *= -1

			var new_rotation = rotator.rotation_degrees + rotate_speed * rotation_direction * delta
			rotator.rotation_degrees = fmod(new_rotation, 360)
		else:
			
			change_to_idle_mode()
			current_speed = 0
			anim.play("idle")
			player.reset()
			
			
func change_to_attack_mode():
	if player.get_player_alive():
		player.enable_input_capture(true)
		current_speed = attack_speed
		clear_spawn_points()
		anim.play("attack")
		setup_spawn_points()

		idle_timer.stop()
		shoot_timer.wait_time = time_between_shots
		shoot_timer.start()

func _on_idle_timer_timeout():
	change_pattern()
	change_to_attack_mode()
	mode_timer.start()

func change_to_null_mode():
	current_speed = 0
	$NullMode.start()
	shoot_timer.stop()
	mode_timer.stop()
	anim.offset = hurt_offset  
	anim.play("hurt")
	seleccionar_texto_aleatorio()
	player.set_text(textito)
	player.enable_input_capture(false)
	
func clear_spawn_points():
	for child in rotator.get_children():
		child.queue_free()

func setup_spawn_points():
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var angle = i * (2 * PI / spawn_point_count)
		var pos = Vector2(radius * cos(angle), radius * sin(angle))
		spawn_point.position = pos
		spawn_point.rotation = angle
		rotator.add_child(spawn_point)

func change_to_idle_mode():
	current_speed = idle_speed
	anim.play("run")
	shoot_timer.stop()
	mode_timer.stop()
	idle_timer.start()
	seleccionar_texto_aleatorio()
	
func _on_mode_timer_timeout():
	change_to_idle_mode()

func change_pattern():
	mode = randi() % 4
	if mode != 3:
		mode_timer.wait_time = 10
		
	if mode == 0:
		spawn_point_count = 3
		rotate_speed = 80
		time_between_shots = 0.35
	elif mode == 1:
		spawn_point_count = 6
		rotate_speed = 50
		time_between_shots = 0.35
	elif mode == 2:
		spawn_point_count = 10
		rotate_speed = 100
		time_between_shots = 0.35
	elif mode == 3:
		spawn_point_count = 16
		rotate_speed = 0
		time_between_shots = 0.35
		mode_timer.wait_time = 6

func _on_walk_zone_body_entered(body):
	if body.name == "Player":
		player = body
		body.enable_input_capture(true)
		textito = $RichTextLabel.text
		body.set_text(textito)

func _on_walk_zone_body_exited(body):
	if body.name == "Player":
		player = null
		seleccionar_texto_aleatorio()
		body.enable_input_capture(false)
		body.set_text("")

func _on_null_mode_timeout():
	change_to_attack_mode()
	change_pattern()
	mode_timer.start()
	anim.offset = normal_offset
	
func death():
	if not $DeathTimer.is_stopped():  # Verificar si el temporizador ya está en marcha
		return  # Evitar reiniciar el temporizador si ya está activo
	player.enable_input_capture(false)
	shoot_timer.stop()
	idle_timer.stop()
	mode_timer.stop()
	anim.play("death")
	current_speed = 0
	$DeathTimer.start()  # Asegurarse de que se inicie el temporizador
	anim.offset = normal_offset
	musica.stop()
	$death.play()
	#var cura_instance = cura.instance()
	#cura_instance.position = global_position
	#get_tree().get_root().add_child(cura_instance)
	#$death.play()
	
func _on_death_timer_timeout():
	self.queue_free()
