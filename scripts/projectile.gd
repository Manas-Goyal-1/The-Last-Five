extends Area2D

const DAMAGE = 10
const SPEED = 275
var target: Vector2


# Momvement
func _process(delta: float) -> void:
	var direction: Vector2 = target - position
	var velocity = direction.normalized() * SPEED
	self.position += velocity * delta

	if abs(position.x) > get_viewport_rect().size.x or abs(position.y) > get_viewport_rect().size.y or direction.length() < 3:
		queue_free()



func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("zombies"):
		return
	
	area.take_damage(DAMAGE)
	queue_free()
