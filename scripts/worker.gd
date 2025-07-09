extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if randi_range(0, 1):
		sprite.texture = load("res://assets/sprites/workers/male_worker.png")
	else:
		sprite.texture = load("res://assets/sprites/workers/female_worker.png")

func move_to(pos):
	get_tree().create_tween().tween_property(self, "position", pos, 1)
