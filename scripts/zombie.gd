extends Area2D

var max_health = 20
var speed = 25
var health = max_health
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var target

# Player Damage stuff
var player_damage
var player
@onready var player_attack_timer: Timer = $PlayerAttackTimer

# Attack the weapons stuff
var weapon_damage
var weapons = []
@onready var weapon_attack_timer: Timer = $WeaponAttackTimer

var bunker_attack = 0.5
#@onready var bunker = $"../../"
@onready var game_manager = get_tree().get_current_scene().get_node("%GameManager")
@onready var bunker_attack_timer: Timer = $BunkerAttackTimer

func setup(difficulty):
	max_health = 20 + 2*difficulty
	player_damage = 2 + difficulty
	weapon_damage = 1 + difficulty
	bunker_attack = difficulty * 0.5
	health = max_health

# Momvement
func _process(delta: float) -> void:
	var direction = target - position
	
	# If close enough to the source, stop
	if direction.length() <= 10:
		if bunker_attack_timer.is_stopped():
			bunker_attack_timer.start()
		return
		
	if direction.x > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	
	# velocity is built in
	var velocity = direction.normalized() * speed
	
	self.position += velocity * delta


func take_damage(damage):
	animated_sprite.play("hit")
	health -= damage
	if health <= 0:
		queue_free()


func _on_bunker_attack_timer_timeout() -> void:
	game_manager.take_damage(bunker_attack)


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
	player.take_damage(player_damage)
	self.take_damage(player_damage)


# To damage the weapons
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapons"):
		weapons.append(area)
		weapon_attack_timer.start()

func _on_area_exited(area: Area2D) -> void:
	weapon_attack_timer.stop()

func _on_weapon_attack_timer_timeout() -> void:
	for weapon in weapons:
		weapon.take_damage(weapon_damage)
