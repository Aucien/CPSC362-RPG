extends KinematicBody2D

const MAX_SPEED = 200
const FRICTION = 800
const ACCELERATION = 800

var velocity = Vector2.ZERO

onready var initial_scale = scale
onready var animationPlayer = $AnimationPlayer
onready var animationState = $AnimationTree.get("parameters/playback")
#func _ready():
	#$AnimationTree.active = true

func _physics_process(delta):
	keyboard_input(delta)
	
func keyboard_input(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		#$AnimationTree.set("parameters/Idle", input_vector)
		#$AnimationTree.set("parameters/Run", input_vector)
		if input_vector.x > 0:
			scale.x = initial_scale.x * sign(scale.y)
		elif input_vector.x < 0:
			scale.x = -initial_scale.x * sign(scale.y)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#var movement = input_vector * MAX_SPEED * delta
	#input_vector = move_and_slide(movement)
	velocity = move_and_slide(velocity)
	
