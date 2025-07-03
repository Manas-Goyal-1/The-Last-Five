extends Node2D


func move_to(pos):
	get_tree().create_tween().tween_property(self, "position", pos, 1)
