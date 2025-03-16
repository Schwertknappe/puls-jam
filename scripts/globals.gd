extends Node

var first_run = true
var completed_runs = 0

var SPEED = 200.0 
var JUMP_VELOCITY = -300.0
var coyote_time_length = 0.2
var DOUBLE_JUMP_VELOCITY = -300.0
var WALLJUMP_VELOCITY = Vector2(200.0, -300.0)
var wall_cling_modifier = 0.4
var climb_speed = 100.0

var jump_enabled : bool = true
var double_jump_enabled : bool = true
var wallcling_enabled : bool = true
var walljump_enabled : bool = true
var gravity_modifier: float = 1.0
var horizontal_jump_direction: float = 0.0
var randomize_horizontal_jump_direction: bool = false
var mirror_input : bool = false
var collides_with_walls : bool = true
var can_shoot : bool = true
var can_walk_left: bool = true
var can_walk_right: bool = true
