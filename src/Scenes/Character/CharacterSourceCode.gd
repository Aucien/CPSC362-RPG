extends KinematicBody2D

const MAX_SPEED = 200
const GRAVITY = 15
const FRICTION = 800
const ACCELERATION = 800
const JUMP_PW= -350

onready var initial_scale = scale
var velocity = Vector2.ZERO
var on_ground = false

onready var animationPlayer = $AnimationPlayer
onready var animationState = $AnimationTree.get("parameters/playback")

func _ready():
	pass
		
func _physics_process(delta):
	move_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			velocity.x = MAX_SPEED
			scale.x = initial_scale.x * sign(scale.y)
		elif input_vector.x < 0:
			velocity.x = -MAX_SPEED
			scale.x = -initial_scale.x * sign(scale.y)
		animationState.travel("Run")
	else:
		velocity.x = 0
		animationState.travel("Idle")
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		animationState.travel("Jump")
		velocity.y = JUMP_PW
	
	velocity.y += GRAVITY 
	
	if is_on_floor():
		on_ground == true
	else:
		on_ground == false	
		if velocity.y < 0:
			animationState.travel("Jump")
		else:
			animationState.travel("Fall")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	


