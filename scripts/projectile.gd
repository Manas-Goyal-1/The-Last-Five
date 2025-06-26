extends Area2D

const DAMAGE = 20
const SPEED = 130
var target_pos: Vector2


# Momvement
func _process(delta: float) -> void:
	var direction: Vector2 = target_pos - position
	var velocity = direction.normalized() * SPEED
	self.position += velocity * delta
	queue_redraw()
	
	if abs(position.x) > get_viewport_rect().size.x or abs(position.y) > get_viewport_rect().size.y or direction.length() < 3:
		queue_free()



func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("zombies"):
		print(area.name)
		return
	
	area.take_damage(DAMAGE)
	queue_free()


#func _draw() -> void:
	#draw_circle(target_pos - position, 2, Color(1, 0, 0), true)
