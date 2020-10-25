extends KinematicBody2D

var hp = 1
var FLOOR = Vector2(0,-1)
var knockback = Vector2.ZERO
const MAX_SPEED = 20
const GRAVITY = 20
var state = IDLE

enum {
	IDLE,
	TAKE_HIT,
	DEATH
}

onready var initial_scale = scale
onready var animationPlayer = $AnimationMush
onready var animationState = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta)
		TAKE_HIT:
			take_hit(delta)
		DEATH:
			death_state(delta)
		
	knockback = knockback.move_toward(knockback, 200*delta)
	knockback = move_and_slide(knockback)
	if hp <= 0:
		state = DEATH

func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox":
		hp -= area.damage
		state = TAKE_HIT
		print(hp)
		
func idle_state(delta):
	animationState.travel("Idle")

func take_hit(delta):
	animationState.travel("Take Hit")
	
func death_state(delta):
	animationState.travel("Death")

		


	
	

