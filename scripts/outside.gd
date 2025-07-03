extends Node2D

@onready var zombie_spawner_timer: Timer = $ZombieSpawnerTimer
@onready var source: AnimatedSprite2D = $Source
@onready var camera: Camera2D = $Camera

const ZombieScene = preload("res://scenes/zombie.tscn")

func _on_zombie_spawner_timer_timeout() -> void:
	var zombie = ZombieScene.instantiate()
	
	var radius = 150
	# Randomly spawning zombies outside a radius of radius
	var x = randf_range(-radius, radius)
	var y = sqrt(radius**2 - x**2) * (randi_range(0, 1)*2-1)	# Makes sure that the y can be positive or negative
	
	# Adds a bit more randomness so they don't spawn right on that circle's boundary
	x += randf_range(-10, 50) * (int(x>0)*2-1)
	y += randf_range(-10, 50) * (int(y>0)*2-1)
	
	#print(str(x) + ", " + str(y))
	zombie.position = Vector2(x, y)
	zombie.target = source.position
	
	get_node("Zombies").add_child(zombie)
	#add_child(zombie)

func set_visibility(visibility):
	visible = visibility
	if visible:
		process_mode = Node.PROCESS_MODE_INHERIT
		camera.make_current()
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
