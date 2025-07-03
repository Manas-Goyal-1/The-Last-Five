extends Area2D

# Not quite sure how this works, but apparently it only lets the variable be these things
enum ResourceTypes {WOOD, MONEY, ONE_MORE_THING}
@export var resource_type: ResourceTypes
@onready var game_manager = get_tree().get_current_scene().get_node("%GameManager")
@onready var timer: Timer = $Timer

@onready var popup: Control = $Popup
@onready var subtract_button: Button = $Popup/Panel/VBoxContainer/HBoxContainer/SubtractButton
@onready var num_workers_label: Label = $Popup/Panel/VBoxContainer/HBoxContainer/NumWorkersLabel
@onready var add_button: Button = $Popup/Panel/VBoxContainer/HBoxContainer/AddButton


var workers = []
var wait_time = 9
var resource_count = 0

# When player enters its area
func _on_body_entered(body: Node2D) -> void:
	# Control UI Thing
	popup.visible = true
	_reset_UI()
	
	# Collect resource
	if resource_type == ResourceTypes.WOOD:
		game_manager.wood += resource_count
	elif resource_type == ResourceTypes.MONEY:
		game_manager.money += resource_count
	else:
		game_manager.another_resource += resource_count
	resource_count = 0


func _on_body_exited(body: Node2D) -> void:
	popup.visible = false


func _on_subtract_button_pressed() -> void:
	game_manager.workers.append(workers.pop_back())
	_reset_UI()


func _on_add_button_pressed() -> void:
	workers.append(game_manager.workers.pop_back())
	_reset_UI()


func _reset_UI():
	num_workers_label.text = str(workers.size())
	
	if game_manager.workers.is_empty():
		add_button.disabled = true
	else:
		add_button.disabled = false

	if workers.is_empty():
		subtract_button.disabled = true
	else:
		subtract_button.disabled = false
	
	print(add_button.disabled, subtract_button.disabled)

func _on_timer_timeout() -> void:
	resource_count += 1
	if workers.size():	# If no workers, don't produce resource
		start_timer()

func start_timer():
	timer.wait_time = wait_time - workers.size() * 2
	timer.start()
