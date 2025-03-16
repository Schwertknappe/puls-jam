extends CharacterBody2D
class_name Enemy

func _ready():
	$AnimationPlayer.play("walking")
