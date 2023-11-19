extends TextureProgressBar

@export var boss : Reaper

# Called when the node enters the scene tree for the first time.
func _ready():
	boss.healthChanged.connect(update)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	if boss and boss.currentHealth != null:
		value = boss.currentHealth * 100 / boss.maxHealth
	else:
		print("h")
