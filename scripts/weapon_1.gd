extends Weapon
class_name BowAndArrow

var ArrowScene = preload("res://scenes/arrow.tscn")
@onready var sprite: Sprite2D = $Sprite2D

#const build_cost = [0, 0, 0]
#const upgrade_cost = [0, 0, 0]

const build_cost = [0, 8, 0]
const upgrade_cost = [5, 4, 2]

func _ready() -> void:
	setup(10, 1, 60, ArrowScene)
	super._ready()

func get_target():
	## Random Zombie
	return zombies.get_children()[randi_range(0, zombies.get_child_count()-1)]

func upgrade():
	super.upgrade()
	sprite.texture = load("res://assets/sprites/weapons/bow_and_arrow/bow" + str(level) + ".png")
