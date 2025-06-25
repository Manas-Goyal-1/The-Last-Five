extends Node2D

const SPEED = 20
const MAX_HEALTH = 20
var health = MAX_HEALTH

@onready var animated_sprite = $AnimatedSprite2D # use this to change animation when moving
@onready var damage_zone: Area2D = $damage_zone
var target: AnimatedSprite2D

func _ready():
	damage_zone.set_damage(3)


func _physics_process(delta: float) -> void:
	var direction = target.position - position
	# velocity is built in
	var velocity = direction.normalized() * SPEED
	
	self.position += velocity * delta


func take_damage(damage):
	health -= damage
	
	if health < 0:
		health = 0
	
