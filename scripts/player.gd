extends CharacterBody2D
signal hit

@export var jump_endabled : bool = true
@export var double_jump_enabled : bool = true

enum State {IDLE, WALKING, JUMPING, LANDING}

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = JUMP_VELOCITY

var current_speed = SPEED
var double_jump_available = false
var start_position
var state : State = State.IDLE
var input_enabled : bool = true

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collider : CollisionShape2D = $CollisionShape2D

func _ready():
	start_position = transform.get_origin()
	if double_jump_enabled:
		double_jump_available = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# check if player just landed and reset double jump
	if is_on_floor() and state == State.JUMPING:
		_land()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and _can_jump():
		_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction and input_enabled:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	_handle_animation(delta, direction)
	
	move_and_slide()


func _can_jump() -> bool:
	return jump_endabled and (is_on_floor() or (!is_on_floor() and double_jump_available))

func _jump():
	current_speed = SPEED
	state = State.JUMPING
	velocity.y = JUMP_VELOCITY
	animation_player.play("jump")
	
	# use double jump
	if not is_on_floor():
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

func _handle_animation(delta, direction):
	if direction != 0.0 and velocity.x < 0.0 != sprite.flip_h:
		sprite.flip_h = !sprite.flip_h
	
	if velocity.x != 0.0 and state != State.JUMPING and state != State.LANDING:
		animation_player.play("walk")
		state = State.WALKING
	elif is_on_floor() and state != State.LANDING and state != State.JUMPING:
		state = State.IDLE
		animation_player.play("idle")


func respawn():
	show()
	collider.set_deferred("disabled", false)
	transform.origin = start_position
	sprite.flip_h = false
	animation_player.play("idle")
	state = State.IDLE



# SIGNALS

func _on_area_2d_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	collider.set_deferred("disabled", true) # Replace with function body.
	respawn()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "land":
		current_speed = SPEED
		state = State.IDLE
