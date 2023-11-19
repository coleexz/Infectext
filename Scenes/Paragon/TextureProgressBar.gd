extends TextureProgressBar

@export var paragon: Paragon

# Called when the node enters the scene tree for the first time.
func _ready():
	paragon.healthChanged.connect(update)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	if paragon and paragon.currentHealth != null:
		value = paragon.currentHealth * 100 / paragon.maxHealth
	else:
		print("h")

