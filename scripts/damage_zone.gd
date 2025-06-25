extends Area2D

@onready var timer: Timer = $Timer
var player
var damage

func _on_body_entered(body: Node2D) -> void:
	player = body
	timer.start()


func _on_body_exited(body: Node2D) -> void:
	timer.stop()


func _on_timer_timeout() -> void:
	player.take_damage(damage)


func set_damage(dmg):
	damage  = dmg
