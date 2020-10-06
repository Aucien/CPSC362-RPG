extends KinematicBody2D

enum{
	IDLE,
	MOVE,
	ATTACK,
}

var velocity = Vector2.ZERO
var state = IDLE;


onready var animation_state = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	match state:
		IDLE:
			pass
		MOVE:
			pass
		ATTACK:
			pass

func idle_state():
	animation_state.travel("Idle")

func move_state():
	
