extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var speed = 150

func _ready():
	anim.play("idle_down")

func _physics_process(delta):
	var dir = Input.get_vector("right","left","up","down")
	velocity = dir * speed
	
	var mouse_pos = get_global_mouse_position()
	var dir_to_mouse = mouse_pos - global_position

	if dir == Vector2.ZERO:
		anim.stop()
	else:
		if dir.x > 0:
			anim.play("walk_right")
		elif dir.x < 0:
			anim.play("walk_left")
		elif dir.y > 0:
			anim.play("walk_down")
		elif dir.y < 0:
			anim.play("walk_up")

	move_and_slide()
