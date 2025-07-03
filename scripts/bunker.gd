extends Node2D

@onready var camera: Camera2D = $Camera
@onready var player = %Player

func _process(delta: float) -> void:
	camera.position.x = player.position.x

func set_visibility(visibility):
	visible = visibility
	if visible:
		process_mode = Node.PROCESS_MODE_INHERIT
		camera.make_current()
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
