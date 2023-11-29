extends CharacterBody2D



func _on_pocion_salud_body_entered(body):
	if body.name == "Player" or body.name == "player":
		self.queue_free()
