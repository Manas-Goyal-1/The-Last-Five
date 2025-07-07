extends Node2D

@onready var zombie_spawner_timer: Timer = $ZombieSpawnerTimer
@onready var source: AnimatedSprite2D = $Source
@onready var camera: Camera2D = $Camera
@onready var player = %Player
@onready var zombies: Node2D = $Zombies
@onready var weapons: Node2D = $Weapons
@onready var game_manager = get_tree().get_current_scene().get_node("%GameManager")
@onready var next_difficulty_timer: Timer = $NextDifficultyTimer


const ZombieScene = preload("res://scenes/zombie.tscn")
var difficulty = 1

const BowScene = preload("res://scenes/bow_and_arrow.tscn")
const SwordScene = preload("res://scenes/sword_thrower.tscn")


func _process(delta: float) -> void:
	camera.position = player.position
	
	## To build weapons
	if Input.is_action_just_pressed("g"):
		if game_manager.can_buy(BowAndArrow.build_cost):
			game_manager.buy(BowAndArrow.build_cost)
			var weapon = BowScene.instantiate()
			weapon.position = player.position
			weapons.add_child(weapon)
	
	if Input.is_action_just_pressed("h"):
		if game_manager.can_buy(SwordThrower.build_cost):
			game_manager.buy(SwordThrower.build_cost)
			var weapon = SwordScene.instantiate()
			weapon.position = player.position
			weapons.add_child(weapon)
	
	if Input.is_action_just_pressed("u"):
		for weapon in weapons.get_children():
			if weapon.is_upgradeable() and game_manager.can_buy(weapon.upgrade_cost):
				weapon.upgrade()
				game_manager.buy(weapon.upgrade_cost)


func _on_zombie_spawner_timer_timeout() -> void:
	var zombie = ZombieScene.instantiate()
	
	var radius = 250
	# Randomly spawning zombies outside a radius of radius
	var x = randf_range(-radius, radius)
	var y = sqrt(radius**2 - x**2) * (randi_range(0, 1)*2-1)	# Makes sure that the y can be positive or negative
	
	# Adds a bit more randomness so they don't spawn right on that circle's boundary
	x += randf_range(-50, 150) * (int(x>0)*2-1)
	y += randf_range(-50, 150) * (int(y>0)*2-1)
	
	#print(str(x) + ", " + str(y))
	zombie.position = Vector2(x, y)
	zombie.target = source.position
	
	zombies.add_child(zombie)
	zombie.setup(difficulty)


func set_visibility(visibility):
	visible = visibility
	if visible:
		process_mode = Node.PROCESS_MODE_INHERIT
		camera.make_current()
	else:
		process_mode = Node.PROCESS_MODE_DISABLED


func _on_next_difficulty_timer_timeout() -> void:
	difficulty += 1
	zombie_spawner_timer.wait_time *= 0.95
	print(difficulty)
