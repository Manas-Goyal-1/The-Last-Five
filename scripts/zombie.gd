extends Area2D

const SPEED = 30
const MAX_HEALTH = 20
var health = MAX_HEALTH
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var target

# Player Damage stuff
const PLAYER_ATTACK = 3
var player
@onready var player_attack_timer: Timer = $PlayerAttackTimer

# Attack the weapons stuff
const WEAPON_ATTACK = 2
var weapon
@onready var weapon_attack_timer: Timer = $WeaponAttackTimer


# Momvement
func _process(delta: float) -> void:
	var direction = target - position
	
	if direction.x > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	
	# velocity is built in
	var velocity = direction.normalized() * SPEED
	self.position += velocity * delta


func take_damage(damage):
	animated_sprite.play("hit")
	health -= damage
	if health <= 0:
		queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.play("move")


# To damage the player
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player = body
	player_attack_timer.start()

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_attack_timer.stop()

func _on_player_attack_timer_timeout() -> void:
	player.take_damage(PLAYER_ATTACK)


# To damage the weapons
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapons"):
		weapon = area
		weapon_attack_timer.start()

func _on_area_exited(area: Area2D) -> void:
	weapon_attack_timer.stop()

func _on_weapon_attack_timer_timeout() -> void:
	weapon.take_damage(WEAPON_ATTACK)
