extends Node2D

const SPEED = 20
const MAX_HEALTH = 20
var health = MAX_HEALTH
var target: AnimatedSprite2D

# Damage stuff
var damage = 3
var player
@onready var timer: Timer = $Timer

# Momvement
func _physics_process(delta: float) -> void:
	var direction = target.position - position
	# velocity is built in
	var velocity = direction.normalized() * SPEED
	self.position += velocity * delta


func take_damage(damage):
	health -= damage
	if health < 0:
		health = 0

# To damage the player
func _on_body_entered(body: Node2D) -> void:
	player = body
	timer.start()

func _on_body_exited(body: Node2D) -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	player.take_damage(damage)
