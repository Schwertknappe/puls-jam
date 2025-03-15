extends Area2D

var travelled_distance = 0
var direction: Vector2 = Vector2.RIGHT


func _physics_process(delta: float) -> void:
	const SPEED = 1000
	
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	const MAX_RANGE = 500
	if travelled_distance > MAX_RANGE:
		queue_free()
