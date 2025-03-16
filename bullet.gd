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


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		queue_free()
		body.queue_free()
	if body is not Player and body is CollisionShape2D:
		queue_free()
