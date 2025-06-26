extends Area2D

const SPEED = 20
const MAX_HEALTH = 20
var health = MAX_HEALTH
var target: AnimatedSprite2D

# Player Damage stuff
var player_attack = 3
var player
@onready var player_attack_timer: Timer = $PlayerAttackTimer

# Attack the weapons stuff
var weapon_attack = 2
var weapon
@onready var weapon_attack_timer: Timer = $WeaponAttackTimer

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
	player_attack_timer.start()

func _on_body_exited(body: Node2D) -> void:
	player_attack_timer.stop()

func _on_player_attack_timer_timeout() -> void:
	player.take_damage(player_attack)


# To damage the player
func _on_area_entered(body: Node2D) -> void:
	weapon = body
	weapon_attack_timer.start()

func _on_area_exited(body: Node2D) -> void:
	weapon_attack_timer.stop()

func _on_weapon_attack_timer_timeout() -> void:
	weapon.take_damage(weapon_attack)
