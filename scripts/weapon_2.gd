extends Weapon
class_name SwordThrower

var SwordScene = preload("res://scenes/sword.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var source = $"../../Source"

#const build_cost = [0, 0, 0]
#const upgrade_cost = [0, 0, 0]

const build_cost = [5, 15, 0]
const upgrade_cost = [10, 5, 5]

func _ready() -> void:
	setup(20, 1.5, 80, SwordScene)
	super._ready()

func get_target():
	var zombie_list = zombies.get_children();
	var min_dist = (zombie_list[0].position - source.position).length()
	var closest = zombie_list[0]
	for zombie in zombie_list:
		var dist = (zombie.position - source.position).length()
		if dist < min_dist:
			min_dist = dist
			closest = zombie
		
	return closest


func upgrade():
	super.upgrade()
	sprite.texture = load("res://assets/sprites/weapons/sword_thrower/cannon" + str(level) + ".png")
