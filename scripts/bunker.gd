extends Node2D

@onready var camera: Camera2D = $Camera
@onready var player = %Player
@onready var timer: Timer = $Timer
@onready var game_manager = get_tree().get_current_scene().get_node("%GameManager")

#var health = 200

func _process(delta: float) -> void:
	camera.position.x = player.position.x

func set_visibility(visibility):
	visible = visibility
	if visible:
		camera.make_current()
		timer.start()
	else:
		timer.stop()


func _on_timer_timeout() -> void:
	#health -= 1
	#print(health)
	game_manager.take_damage(0.1)
