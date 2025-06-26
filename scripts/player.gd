extends CharacterBody2D


const SPEED = 100
const MAX_HEALTH = 100
var health = MAX_HEALTH

@onready var animated_sprite = $AnimatedSprite2D # use this to change animation when moving
@onready var health_label: Label = $Health	# Just temporary until we make a health bar


func _process(delta: float) -> void:
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	
	# velocity is built in
	velocity = direction.normalized() * SPEED
	
	move_and_slide()


func take_damage(damage):
	health -= damage
	
	if health < 0:
		health = 0
	
	health_label.text = str(health)
