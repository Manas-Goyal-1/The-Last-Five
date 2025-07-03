extends Node

@onready var outside: Node2D = $"../Outside"
@onready var bunker: Node2D = $"../Bunker"
@onready var player: CharacterBody2D = $"../Player"

# Resources for inventory
var wood = 0
var money = 0
var water = 0
var workers

## To manage scenes
func _ready() -> void:
	# Need to do 'await' so the scenes can load properly
	await outside.ready
	await bunker.ready
	show_outside()
	
	workers = $"../Bunker/Workers".get_children()


func _process(delta: float) -> void:
	# Check to switch screen
	if Input.is_action_just_pressed("RightClick"):
		if outside.is_visible_in_tree():
			show_bunker()
		else:
			show_outside()

		#camera.position.x = player.position.x


func show_bunker():
	bunker.set_visibility(true)
	outside.set_visibility(false)
	player.to_bunker()


func show_outside():
	bunker.set_visibility(false)
	outside.set_visibility(true)
	player.to_outside()
