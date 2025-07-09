extends CharacterBody2D

const GRAVITY = 0.3
const SPEED = 200
const MAX_HEALTH = 100
var health
var is_outside

@onready var animated_sprite = $AnimatedSprite2D # use this to change animation when moving
@onready var health_label: Label = $Health	# Just temporary until we make a health bar
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var game_manager = get_tree().get_current_scene().get_node("%GameManager")

var tween

func _ready() -> void:
	reset()

func reset():
	health = MAX_HEALTH
	to_bunker()
	update_health_bar(0.3)


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
	
	if velocity.x == 0:
		animated_sprite.play("idle")
	else:
		if animated_sprite.animation != "walk":
			animated_sprite.play("walk")
		if velocity.x > 0:
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			animated_sprite.flip_h = true

	
	
	move_and_slide()


func take_damage(damage):
	health -= damage
	
	if health <= 0:
		game_manager.respawn()
	
	update_health_bar(damage/20)
	#health_bar.value = health
	#health_label.text = str(health)

func update_health_bar(time):
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_property(health_bar, "value", health, time)

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
