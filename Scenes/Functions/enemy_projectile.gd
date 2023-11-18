extends Area2D

@export var speed = 400

func _physics_process(delta):
	position+=transform.x * speed * delta
	

func _on_lifetime_timer_timeout():
	self.queue_free()


func _on_body_entered(body):
	if body.name == "Player":
		body.reduce_health(20)
