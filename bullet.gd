extends Area2D

var travelled_distance = 0
var direction: Vector2 = Vector2.RIGHT

@onready var sfx_player = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	const SPEED = 1000
	
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	const MAX_RANGE = 500
	if travelled_distance > MAX_RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		$Projectile.visible = false
		$CollisionShape2D.disabled = true
		if body is Enemy:
			sfx_player.stream = load("res://assets/sfx/enemy_death_sound.wav")
			sfx_player.play()
			body.queue_free()


func _on_audio_stream_player_2d_finished():
	queue_free()
