extends Projectile

@onready var sprite: Sprite2D = $Sprite2D

var level

func _ready() -> void:
	set_level()
	super._ready()

func set_level():
	sprite.texture = load("res://assets/sprites/weapons/sword_thrower/sword" + str(level) + ".png")
