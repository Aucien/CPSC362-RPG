extends KinematicBody2D

export var MAX_SPEED = 200
export var GRAVITY = 20
export var ACCELERATION = 80
export var JUMP_PW= -400

var state = MOVE
var velocity = Vector2.ZERO

onready var initial_scale = scale
onready var animationPlayer = $AnimationPlayer
onready var animationState = $AnimationTree.get("parameters/playback")
onready var swordHitbox = $Position2D/Hitbox

enum {
	MOVE,
	ATTACK_1,
	ATTACK_2,
	ATTACK_3
	DEATH,
	BLOCK
}

func _ready():
	swordHitbox.knockback_vector = Vector2.ZERO

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK_1:
			attack_state1(delta)
		ATTACK_2:
			attack_state2(delta)
		ATTACK_3:
			attack_state3(delta)
		BLOCK:
			pass
		DEATH:
			death_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	var on_ground = false

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		swordHitbox.knockback_vector = input_vector
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
			velocity.x = lerp(velocity.x, 0 , 0.1)
		
		#While not jump	
		if Input.is_action_just_pressed("attack1"):
			state = ATTACK_1
		if Input.is_action_just_pressed("attack2"):
			state = ATTACK_2
		if Input.is_action_just_pressed("attack3"):
			state = ATTACK_3
	else:
		if velocity.y < 0:
			animationState.travel("Jump")
		else:
			animationState.travel("Fall")
			if velocity.y > 2000: #stop endless falling (temporary)
				get_tree().reload_current_scene()
				
		if on_ground == true:
			velocity.x = lerp(velocity.x, 0 , 0.01)

	velocity = move_and_slide(velocity, Vector2.UP)
		
func attack_state1(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack_1")

func attack_state2(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack_2")

func attack_state3(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack_3")
		
func attack_finished():
	state = MOVE
	
func death_state(delta):
	animationState.travel("Death")
		
	
