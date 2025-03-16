extends Area2D


func _on_body_entered(body):
	if body is Player:
		Globals.first_run = false
		Globals.completed_runs += 1
		
		if Globals.completed_runs >= 3:
			get_tree().change_scene_to_file("res://scenes/menus/game_finish_screen.tscn")
			Globals.first_run = true
			Globals.completed_runs = 0
			Globals.chosen_restrictions = []
		else:
			Globals.SPEED = body.SPEED
			Globals.JUMP_VELOCITY = body.JUMP_VELOCITY
			Globals.coyote_time_length = body.coyote_time_length
			Globals.DOUBLE_JUMP_VELOCITY = body.DOUBLE_JUMP_VELOCITY
			Globals.WALLJUMP_VELOCITY = body.WALLJUMP_VELOCITY
			Globals.wall_cling_modifier = body.wall_cling_modifier
			Globals.climb_speed = body.climb_speed

			Globals.jump_enabled = body.jump_enabled
			Globals.double_jump_enabled = body.double_jump_enabled
			Globals.wallcling_enabled = body.wallcling_enabled
			Globals.walljump_enabled = body.walljump_enabled
			Globals.gravity_modifier = body.gravity_modifier
			Globals.horizontal_jump_direction = body.horizontal_jump_direction
			Globals.randomize_horizontal_jump_direction = body.randomize_horizontal_jump_direction
			Globals.mirror_input = body.mirror_input
			Globals.collides_with_walls = body.collides_with_walls
			Globals.can_shoot = body.can_shoot
			Globals.can_walk_left = body.can_walk_left
			Globals.can_walk_right = body.can_walk_right
			
			get_tree().reload_current_scene()
