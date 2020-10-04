extends KinematicBody2D

export var max_speed = 200
export var friction = 800
export var acceleration = 800
export var gravity = 15

var velocity = Vector2.ZERO

onready var initial_scale = scale
onready var animation_state = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	keyboard_input(delta)
	
	velocity.y +=gravity;
	velocity = move_and_slide(velocity, Vector2.UP)
	
func keyboard_input(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_just_pressed("ui_up"):
		input_vector.y = -100.0
	input_vector = input_vector.normalized()
	print(input_vector)
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animation_state.travel("Run")
			scale.x = initial_scale.x * sign(scale.y)
		elif input_vector.x < 0:
			animation_state.travel("Run")
			scale.x = -initial_scale.x * sign(scale.y)
		if velocity.y < 0:
			animation_state.travel("Jump")
		#velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		
		velocity = input_vector * max_speed
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
