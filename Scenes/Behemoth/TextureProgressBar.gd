extends TextureProgressBar

@export var behemoth : Behemoth

# Called when the node enters the scene tree for the first time.
func _ready():
	behemoth.healthChanged.connect(update)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	if behemoth and behemoth.currentHealth != null:
		value = behemoth.currentHealth * 100 / behemoth.maxHealth
	else:
		print("h")

