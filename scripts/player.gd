extends CharacterBody2D

const GRAVITY = 0.3
const SPEED = 150
const MAX_HEALTH = 100
var health = MAX_HEALTH
var is_outside

@onready var animated_sprite = $AnimatedSprite2D # use this to change animation when moving
@onready var health_label: Label = $Health	# Just temporary until we make a health bar


func _process(delta: float) -> void:
	
	if is_outside:
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
	else:
		var direction = 0
		velocity.y += GRAVITY * SPEED
		if Input.is_action_pressed("right"):
			direction += 1
		if Input.is_action_pressed("left"):
			direction -= 1
		
		velocity.x = direction * SPEED
	
	print(velocity.x, velocity.x == 0)
	if velocity.x == 0:
		animated_sprite.play("idle")
	else:
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		if velocity.x > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

	
	
	move_and_slide()


func take_damage(damage):
	health -= damage
	
	if health < 0:
		health = 0
	
	health_label.text = str(health)

func to_bunker():
	is_outside = false
	position = Vector2(55, -30)
	#scale = Vector2(0.8, 0.8)	# So the player looks similar in size in both scenes
	
	self.collision_layer = 1 << 1
	self.collision_mask = 1 << 1

func to_outside():
	is_outside = true
	position = Vector2.ZERO
	scale = Vector2.ONE
	
	self.collision_layer = 1 << 0
	self.collision_mask = 1 << 0
