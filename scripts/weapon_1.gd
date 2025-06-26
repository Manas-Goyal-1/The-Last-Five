extends Area2D

var health = 30

var ProjectileScene = preload("res://scenes/projectile.tscn")
@onready var zombies: Node = $"../Zombies"

func take_damage(damage):
	health -= damage
	if health < 0:
		health = 0


func _on_timer_timeout() -> void:
	var projectile = ProjectileScene.instantiate()
	if zombies.get_child_count() == 0:
		return
	
	projectile.target = zombies.get_children()[randi_range(0, zombies.get_child_count()-1)].position
	projectile.position = position
	
	get_node("../Projectiles").add_child(projectile)
