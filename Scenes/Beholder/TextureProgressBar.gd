extends TextureProgressBar

@export var beholder: Beholder

# Called when the node enters the scene tree for the first time.
func _ready():
	beholder.healthChanged.connect(update)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	value = beholder.currentHealth*100 / beholder.maxHealth
