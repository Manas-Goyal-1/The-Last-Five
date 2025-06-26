extends Area2D

var health = 30

func _process(delta: float) -> void:
	# Spawn projectiles
	pass


func take_damage(damage):
	health -= damage
	if health < 0:
		health = 0
