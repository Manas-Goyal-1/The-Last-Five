extends Area2D

# Not quite sure how this works, but apparently it only lets the variable be these things
enum ResourceTypes {WOOD, MONEY, WATER}
@export var resource_type: ResourceTypes
@onready var game_manager = get_tree().get_current_scene().get_node("%GameManager")

@onready var timer: Timer = $Timer

@onready var popup: Control = $Popup
@onready var subtract_button: Button = $Popup/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SubtractButton
@onready var num_workers_label: Label = $Popup/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NumWorkersLabel
@onready var add_button: Button = $Popup/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/AddButton
const MAX_WORKERS = 3

var workers = []
var wait_time = 8
var resource_count = 0

func _ready() -> void:
	popup.visible = false

# When player enters its area
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	# Control UI Thing
	popup.visible = true
	_update()

	# Collect resource
	if resource_type == ResourceTypes.WOOD:
		game_manager.add_wood(resource_count)
	elif resource_type == ResourceTypes.MONEY:
		game_manager.add_money(resource_count)
	else:
		game_manager.add_water(resource_count)
	#print("Added " + str(resource_count) + " resource")
	resource_count = 0


func _on_body_exited(body: Node2D) -> void:
	popup.visible = false


func _on_subtract_button_pressed() -> void:
	var worker = workers.pop_back()
	game_manager.workers.append(worker)
	worker.move_to(Vector2(randi_range(-5, 15), 65))
	_update()
	_reset_timer()


func _on_add_button_pressed() -> void:
	var worker = game_manager.workers.pop_back()
	workers.append(worker)
	worker.move_to(position + Vector2(20 + randi_range(-5, 5), randi_range(0, 15)))
	_update()
	_reset_timer()

func _update():
	## Updating UI
	num_workers_label.text = str(workers.size())
	
	if game_manager.workers.is_empty() or workers.size() == MAX_WORKERS:
		add_button.disabled = true
	else:
		add_button.disabled = false

	if workers.is_empty():
		subtract_button.disabled = true
	else:
		subtract_button.disabled = false



func _on_timer_timeout() -> void:
	resource_count += 1
	#print("Timer Ended: " + str(resource_count))
	_reset_timer()

func _reset_timer():
	if workers.size() != 0:
		#print("Timer Started")
		timer.wait_time = wait_time - workers.size() * 2
		timer.start()
	else:
		timer.stop()
