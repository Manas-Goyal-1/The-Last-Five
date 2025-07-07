extends Area2D
class_name Projectile

var damage = 10
var speed = 350
var target

func _ready() -> void:
	connect("area_entered", _on_area_entered)

# Momvement
func _process(delta: float) -> void:
	var direction = target - position
	var velocity = direction.normalized() * speed
	self.position += velocity * delta

	if direction.length() < 3:
		queue_free()



func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("zombies"):
		return
	
	area.take_damage(damage)
	queue_free()
