extends CharacterBody2D

@export var can_jump : bool = true
@export var can_double_jump : bool = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jump_available = true
var last_velocity

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# check if player just landed and reset double jump
	if is_on_floor() and !double_jump_available:
		double_jump_available = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump and (is_on_floor() or double_jump_available):
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			double_jump_available = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
