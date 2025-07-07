extends Node

@onready var outside: Node2D = $"../Outside"
@onready var bunker: Node2D = $"../Bunker"
@onready var player: CharacterBody2D = $"../Player"

@onready var money_label: Label = $"../CanvasLayer/InventoryPanel/MarginContainer/GridContainer/MoneyLabel"
@onready var wood_label: Label = $"../CanvasLayer/InventoryPanel/MarginContainer/GridContainer/WoodLabel"
@onready var water_label: Label = $"../CanvasLayer/InventoryPanel/MarginContainer/GridContainer/WaterLabel"
@onready var inventory_panel: PanelContainer = $"../CanvasLayer/InventoryPanel"
@onready var end_screen: TextureRect = $"../CanvasLayer/EndScreen"

# Resources for inventory
var wood = 0
var money = 0
var water = 0
var workers

var health = 200
@onready var health_bar: TextureProgressBar = $"../CanvasLayer/HealthBar"


## To manage scenes
func _ready() -> void:
	# Need to do 'await' so the scenes can load properly
	await outside.ready
	await bunker.ready
	show_bunker()
	
	workers = $"../Bunker/Workers".get_children()

func _process(delta: float) -> void:
	## To change scenes
	if Input.is_action_just_pressed("right_click"):
		if player.is_outside:
			show_bunker()
		else:
			show_outside()

func respawn():
	take_damage(40)
	show_bunker()
	player.reset()
	
	wood = 0
	money = 0
	water = 0

	_update_label(wood_label, wood, 0)
	_update_label(money_label, money, 0)
	_update_label(water_label, water, 0)


func take_damage(dmg):
	health -= dmg
	if health <= 0:
		outside.visible = false
		bunker.visible = false
		player.visible = false
		inventory_panel.visible = false
		health_bar.visible = false
		end_screen.visible = true
		
	get_tree().create_tween().tween_property(health_bar, "value", health, dmg)

func can_buy(cost):
	return money >= cost[0] and wood >= cost[1] and water >= cost[2]

func buy(cost):
	money -= cost[0]
	wood -= cost[1]
	water -= cost[2]
	
	money_label.text = str(money)
	wood_label.text = str(wood)
	water_label.text = str(water)

func show_bunker():
	bunker.set_visibility(true)
	outside.set_visibility(false)
	player.to_bunker()


func show_outside():
	bunker.set_visibility(false)
	outside.set_visibility(true)
	player.to_outside()


## Inventory Stuff
func add_wood(amount):
	_update_label(wood_label, wood, amount)
	wood += amount

func add_money(amount):
	_update_label(money_label, money, amount)
	money += amount

func add_water(amount):
	#water += amount
	_update_label(water_label, water, amount)
	water += amount

func _update_label(label, original, amount):
	get_tree().create_tween().tween_method(func(num): label.text = str(num), original, original+amount, amount/15.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
