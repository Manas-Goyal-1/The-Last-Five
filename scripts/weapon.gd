extends Area2D
class_name Weapon

var ProjectileScene
@onready var zombies: Node = $"../../Zombies"

var damage
var cooldown
var max_health
const MAX_LEVEL = 3
#var build_cost	# [Money, wood, water]
#var upgrade_cost

# Runtime health
var health
var can_upgrade
var level

@onready var timer: Timer = $Timer

func _ready():
	timer.connect("timeout", _on_cooldown_timer_timeout)
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)
	
	reset()

func _process(delta: float) -> void:
	#if can_upgrade and Input.is_action_just_pressed("u"):
		#upgrade()
		## NEED TO DEDUCT RESOURCES TOO
	pass

func setup(damage, cooldown, max_health, projectileScene):
	self.damage = damage
	self.cooldown = cooldown
	self.max_health = max_health
	ProjectileScene = projectileScene
	can_upgrade = false
	level = 1
	#self.build_cost = build_cost
	#self.upgrade_cost = upgrade_cost

func reset():
	health = max_health
	timer.wait_time = cooldown
	timer.start()


func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
	print(health)

func shoot(zombie):

	#print(rad_to_deg(Vector2.ONE.angle_to_point(Vector2(5, 4))))
	
	#rotation = rad_to_deg(zombie.position.angle_to_point(position))
	#rotation = rad_to_deg(Vector2.ZERO.angle_to_point(zombie.position - position))
	#rotation = rad_to_deg((zombie.position - position).angle())
	var rot = (zombie.position - position).angle()
	if rot < 0:
		rot += 2*PI
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", rot, rot/40)
	tween.tween_callback(make_projectile.bind(zombie))

func is_upgradeable():
	return can_upgrade and level < MAX_LEVEL

func make_projectile(zombie):
	if not is_instance_valid(zombie):
		return
	var projectile = ProjectileScene.instantiate()
	projectile.target = zombie.position
	projectile.position = position + Vector2.from_angle(rotation)
	projectile.damage = damage
	
	projectile.rotation = rotation
	projectile.level = level
	get_node("../../Projectiles").add_child(projectile)


func _on_cooldown_timer_timeout() -> void:
	if zombies.get_child_count() == 0:
		return
	
	## Random Zombie
	var zombie = get_target()
	shoot(zombie)

func get_target():
	print("OVERRIDE THIS FREAKING METHOD.")
	return null

func upgrade():
	damage += 5
	cooldown *= 0.85
	level += 1
	reset()

func _on_body_entered(body: Node2D):
	if not body.is_in_group("player"):
		return
	can_upgrade = true

func _on_body_exited(body: Node2D):
	if not body.is_in_group("player"):
		return
	can_upgrade = false
