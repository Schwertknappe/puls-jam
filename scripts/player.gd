extends CharacterBody2D
signal hit

@export_category("General Variables")
@export_range(1, 10, 1) var MAX_LIVES = 3

@export var SPEED = 200.0 
@export var JUMP_VELOCITY = -300.0
@export var DOUBLE_JUMP_VELOCITY = -300.0
@export var WALLJUMP_VELOCITY = Vector2(200.0, -300.0)
@export_range(0.0, 1.0, 0.05) var wall_cling_modifier = 0.4
@export var climb_speed = 100.0

@export_category("Breakable Mechanics")
@export var jump_enabled : bool = true
@export var double_jump_enabled : bool = true
@export var wallcling_enabled : bool = true
@export var walljump_enabled : bool = true
@export_range(-2, 2, 0.1) var gravity_modifier: float = 1.0
@export_range(-1000, 1000, 10) var horizontal_jump_direction: float = 0.0
@export var randomize_horizontal_jump_direction: bool = false
@export var mirror_input : bool = false
@export var collides_with_walls : bool = true
@export var can_shoot : bool = true # not implemented yet
@export var can_walk_left: bool = true
@export var can_walk_right: bool = true

enum State {IDLE, WALKING, JUMPING, LANDING, CLIMBING}

var current_speed = SPEED
var double_jump_available = false
var clinging_to_wall = false
var start_position
var state : State = State.IDLE
var input_enabled : bool = true
var lives_left = MAX_LIVES
var can_climb : bool = false
var current_gravity : Vector2

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collider : CollisionShape2D = $CollisionShape2D
@onready var wall_check : RayCast2D = $WallCheck

func _ready():
	start_position = transform.get_origin()
	if not jump_enabled:
		double_jump_enabled = false
	
	if double_jump_enabled:
		double_jump_available = true
	
	if not collides_with_walls:
		collision_layer &= ~(1 << 2)
		collision_mask &= ~(1 << 2)
	
	current_gravity = get_gravity()

func _physics_process(delta):
	current_gravity = Vector2(0.0,0.0) if state == State.CLIMBING else get_gravity()
	
	# Add the gravity.
	if not is_on_floor():
		if not clinging_to_wall:
			velocity += current_gravity * delta * gravity_modifier
		else: 
			velocity += current_gravity * delta * gravity_modifier * wall_cling_modifier
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction
	if !mirror_input:
		direction = Input.get_axis("move_left", "move_right")
	else:
		direction = Input.get_axis("move_right", "move_left")
	
	_check_wall_cling(direction)
	
	if !can_walk_left:
		direction = clamp(direction, 0.0, 1.0)
	if !can_walk_right:
		direction = clamp(direction, -1.0, 0.0)
	
	if not is_on_floor():
		direction *= 0.1
	
	if direction and input_enabled:
		velocity.x += direction * current_speed
		velocity.x = clamp(velocity.x, -current_speed, current_speed)
	else:
		if is_on_floor() or state == State.CLIMBING:
			velocity.x = move_toward(velocity.x, 0, current_speed)
		elif velocity.x > 0.0:
			velocity.x = move_toward(velocity.x, current_speed/2, current_speed)
		elif velocity.x < 0.0:
			velocity.x = move_toward(velocity.x, -current_speed/2, current_speed)
	
	var v_direction = Input.get_axis("move_up", "move_down")
	if v_direction and can_climb:
		state = State.CLIMBING
		if double_jump_enabled != double_jump_available:
			double_jump_available = double_jump_enabled
		velocity.y = v_direction * climb_speed
	elif state == State.CLIMBING:
		velocity.y = 0.0
	
	# check if player just landed and reset double jump
	if is_on_floor() and state == State.JUMPING:
		_land()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and _can_jump():
		_jump()
	
	_handle_animation(delta, direction)
	
	move_and_slide()


func _can_jump() -> bool:
	return jump_enabled and (is_on_floor() or wall_check.is_colliding() or state == State.CLIMBING or (!is_on_floor() and double_jump_available))

func _jump():
	current_speed = SPEED
	state = State.JUMPING
	velocity.y = JUMP_VELOCITY
	animation_player.play("jump")
	
	if randomize_horizontal_jump_direction:
		var arr = [-1, 1]
		var direction = arr[randi() % arr.size()]
		horizontal_jump_direction = randf_range(300, 1000)*direction
	velocity.x += horizontal_jump_direction
	
	# wall jump
	if wall_check.is_colliding() and not is_on_floor():
		velocity.x = get_wall_normal().x * WALLJUMP_VELOCITY.x
		_flip_horizontally()
	
	# use double jump
	if not is_on_floor() and not wall_check.is_colliding() and state != State.CLIMBING:
		double_jump_available = false
		velocity.y = DOUBLE_JUMP_VELOCITY
		animation_player.stop()
		animation_player.play("jump")


func _land():
	state = State.LANDING
	if double_jump_enabled:
		double_jump_available = true
	current_speed = SPEED*0.75
	animation_player.play("land")

func _check_wall_cling(direction):
	var normalized_direction = 1 if direction < 0 else -1
	
	if wall_check.is_colliding() and normalized_direction == get_wall_normal().x:
		if velocity.y < 0.0:
			velocity.y = 0.0
		clinging_to_wall = true
	
	if clinging_to_wall and not wall_check.is_colliding():
		clinging_to_wall = false

func _handle_animation(delta, direction):
	if direction != 0.0 and velocity.x < 0.0 != sprite.flip_h:
		_flip_horizontally()
	
	if gravity_modifier < 0.0 != sprite.flip_v:
		sprite.flip_v = ! sprite.flip_v
	
	if velocity.x != 0.0 and state != State.JUMPING and state != State.LANDING and state != State.CLIMBING:
		animation_player.play("walk")
		state = State.WALKING
	elif is_on_floor() and state != State.LANDING and state != State.JUMPING:
		state = State.IDLE
		animation_player.play("idle")

func _flip_horizontally():
	sprite.flip_h = !sprite.flip_h
	wall_check.target_position *= -1
	wall_check.transform.origin.x *= -1

func respawn():
	lives_left -= 1
	show()
	collider.set_deferred("disabled", false)
	transform.origin = start_position
	sprite.flip_h = false
	animation_player.play("idle")
	state = State.IDLE
	velocity = Vector2(0.0,0.0)

func die():
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	collider.set_deferred("disabled", true) # Replace with function body.
	if lives_left > 0:
		respawn()
	else:
		input_enabled = false

func tile_has_property(tile_map : TileMapLayer, property : String) -> bool:
	var tile_coords = tile_map.local_to_map(global_position)
	var tile_data : TileData = tile_map.get_cell_tile_data(tile_coords)
	if tile_data != null:
		return tile_data.has_custom_data(property) and tile_data.get_custom_data(property) == true
	return false



# SIGNALS

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		if tile_has_property(body, "is_ladder"):
			can_climb = true
		elif tile_has_property(body, "is_damage"):
			die()
	else:
		die()

func _on_area_2d_body_exited(body):
	if body is TileMapLayer and !tile_has_property(body, "is_ladder"):
		can_climb = false
		state = State.IDLE

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "land":
		current_speed = SPEED
		state = State.IDLE
