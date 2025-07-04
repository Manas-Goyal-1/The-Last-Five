extends Node

@onready var outside: Node2D = $"../Outside"
@onready var bunker: Node2D = $"../Bunker"
@onready var player: CharacterBody2D = $"../Player"

@onready var money_label: Label = $"../CanvasLayer/PanelContainer/MarginContainer/GridContainer/MoneyLabel"
@onready var wood_label: Label = $"../CanvasLayer/PanelContainer/MarginContainer/GridContainer/WoodLabel"
@onready var water_label: Label = $"../CanvasLayer/PanelContainer/MarginContainer/GridContainer/WaterLabel"


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

func add_wood(amount):
	#wood += amount
	#_update_label(wood_label, wood+amount)
	#var tween = get_tree().create_tween()
	##tween.tween_property(self, "wood", str(amount), (amount - wood)/10)
	#tween.tween_method(func(num): wood_label.text = str(num), wood, wood+amount, amount/10)
	#wood += amount
	
	_update_label(wood_label, wood, amount)
	wood += amount

func add_money(amount):
	#money += amount
	_update_label(money_label, money, amount)
	money += amount

func add_water(amount):
	#water += amount
	_update_label(water_label, water, amount)
	water += amount


func _update_label(label: Label, original, amount):
	#print(label.name + ": "+ str(amount))
	
	get_tree().create_tween().tween_method(func(num): label.text = str(num), original, original+amount, amount/15.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "wood", str(amount), (amount - wood)/10)

	
	#var tween = get_tree().create_tween()
	#tween.tween_property(label, "text", str(amount), amount - float(label.text)/10)
	
	#label.text = str(count)

func show_bunker():
	bunker.set_visibility(true)
	outside.set_visibility(false)
	player.to_bunker()


func show_outside():
	bunker.set_visibility(false)
	outside.set_visibility(true)
	player.to_outside()
