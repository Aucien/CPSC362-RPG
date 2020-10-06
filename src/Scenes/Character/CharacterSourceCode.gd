extends KinematicBody2D

const MAX_SPEED = 200
const GRAVITY = 20
const ACCELERATION = 80
const JUMP_PW= -400

var velocity = Vector2.ZERO
onready var initial_scale = scale
onready var animationPlayer = $AnimationPlayer
onready var animationState = $AnimationTree.get("parameters/playback")

func _ready():
	pass

func _physics_process(delta):
	move_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	var on_ground = false

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
			scale.x = initial_scale.x * sign(scale.y)
		elif input_vector.x < 0:
			velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
			scale.x = -initial_scale.x * sign(scale.y)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
		on_ground = true

	velocity.y += GRAVITY 

	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_PW
		if on_ground == true:
			velocity.x = lerp(velocity.x, 0 , 0.2)
	else:
		if velocity.y < 0:
			animationState.travel("Jump")
		else:
			animationState.travel("Fall")
		if on_ground == true:
			velocity.x = lerp(velocity.x, 0 , 0.05)

	velocity = move_and_slide(velocity, Vector2.UP)
