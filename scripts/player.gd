extends CharacterBody2D
signal hit

@export_category("General Variables")
@export_range(1, 10, 1) var MAX_LIVES = 3

@export var SPEED = 200.0 
@export var JUMP_VELOCITY = -300.0
@export var DOUBLE_JUMP_VELOCITY = -300.0
@export var WALLJUMP_VELOCITY = Vector2(200.0, -300.0)
@export_range(0.0, 1.0, 0.05) var wall_cling_modifier = 0.4

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

enum State {IDLE, WALKING, JUMPING, LANDING}

var current_speed = SPEED
var double_jump_available = false
var clinging_to_wall = false
var start_position
var state : State = State.IDLE
var input_enabled : bool = true
var lives_left = MAX_LIVES

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collider : CollisionShape2D = $CollisionShape2D
@onready var wall_check : RayCast2D = $WallCheck

@onready var augment_ui = $AugmentUI

func _ready():
	start_position = transform.get_origin()
	show_augment_selection()
	if not jump_enabled:
		double_jump_enabled = false
	
	if double_jump_enabled:
		double_jump_available = true
	
	if not collides_with_walls:
		collision_layer &= ~(1 << 2)
		collision_mask &= ~(1 << 2)

func show_augment_selection():
	var augments = AugmentData.get_random_augments(3)
	augment_ui.show_augments(augments)
	augment_ui.augment_selected.connect(_on_augment_selected)
	

func _on_augment_selected(augment):
	augment.apply.call(self)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if not clinging_to_wall:
			velocity += get_gravity() * delta * gravity_modifier
		else: 
			velocity += get_gravity() * delta * gravity_modifier * wall_cling_modifier
	
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
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, current_speed)
		elif velocity.x > 0.0:
			velocity.x = move_toward(velocity.x, current_speed/2, current_speed)
		elif velocity.x < 0.0:
			velocity.x = move_toward(velocity.x, -current_speed/2, current_speed)
	
	# check if player just landed and reset double jump
	if is_on_floor() and state == State.JUMPING:
		_land()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and _can_jump():
		_jump()
	
	_handle_animation(delta, direction)
	
	move_and_slide()


func _can_jump() -> bool:
	return jump_enabled and (is_on_floor() or wall_check.is_colliding() or (!is_on_floor() and double_jump_available))

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
	if not is_on_floor() and not wall_check.is_colliding():
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
	
	if velocity.x != 0.0 and state != State.JUMPING and state != State.LANDING:
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



# SIGNALS

func _on_area_2d_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	collider.set_deferred("disabled", true) # Replace with function body.
	if lives_left > 0:
		respawn()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "land":
		current_speed = SPEED
		state = State.IDLE
