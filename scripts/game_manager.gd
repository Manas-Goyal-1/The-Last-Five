extends Node

@onready var outside: Node2D = $"../Outside"
@onready var bunker: Node2D = $"../Bunker"
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	show_outside()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Click"):
		if outside.is_visible_in_tree():
			show_bunker()
		else:
			show_outside()

func show_bunker():
	bunker.visible = true
	outside.visible = false
	player.to_bunker()
	# Disable outside so the zombies and weapons and everysthing stops.
	outside.process_mode = Node.PROCESS_MODE_DISABLED

func show_outside():
	bunker.visible = false
	outside.visible = true
	player.to_outside()
	outside.process_mode = Node.PROCESS_MODE_INHERIT	# Enable outside again
