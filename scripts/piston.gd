extends Area2D


@export var bounce_height = -400

@onready var animation_player : AnimationPlayer = $AnimationPlayer



func _on_body_entered(body):
	if body is Player and !animation_player.is_playing():
		body.velocity.y = bounce_height
		animation_player.play("spring")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "spring":
		animation_player.play("recall")
