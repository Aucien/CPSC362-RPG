extends KinematicBody2D

const MAX_SPEED = 80
const GRAVITY = 20
const ACCELERATION = 80
const FRICTION = 150
const FLOOR = Vector2(0,-1)

var direction = 1
var rng = RandomNumberGenerator.new()
var velocity = Vector2()
var knockback = Vector2.ZERO
var state = IDLE

enum {
	IDLE,
	TAKE_HIT,
	DEATH,
	CHASE,
	ATTACK,
	ROAM
}

onready var roamAI = $RoamingAI
onready var stats = $Stats
onready var hp = stats.health
onready var playerDetectionZone = $PlayerDectection
onready var can_see = $Hurtbox
onready var animationPlayer = $AnimationMush
onready var animationState = $AnimationTree.get("parameters/playback")

func _ready():
	rng.randomize()
	
func _physics_process(delta):
	velocity.y += GRAVITY	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			idle_state(delta)
		TAKE_HIT:
			take_hit(delta)
		DEATH:
			death_state(delta)
		CHASE:
			chase_state(delta)
		ATTACK:
			pass
		ROAM:
			roam_state(delta)

	velocity = move_and_slide(velocity)
	
func detectPlayer():
	if playerDetectionZone.detected():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox":
		hp -= area.damage
		knockback = area.knockback_vector * FRICTION
		state = TAKE_HIT
		print(hp)
		if hp <= 0:
			state = DEATH

func idle_state(delta):
	animationState.travel("Idle")
	velocity.x = 0
	detectPlayer()
	
	if roamAI.get_time_left() == 0:
		print("time left = 0")
		state = pick_random_state([IDLE, ROAM])
		roamAI.start_roaming_timer(rand_range(1,3))

func take_hit(delta):
	animationState.travel("Take Hit")
	
func death_state(delta):
	velocity.x = 0
	animationState.travel("Death")
	
func chase_state(delta):
	var attack_range = 10
	var player = playerDetectionZone.player
	if player != null:
		animationState.travel("Walk")
		var location = global_position.direction_to(player.global_position)
		if player.global_scale.y == 1:
			$Sprite.flip_h =  true
			velocity.x = -max(location.x + ACCELERATION, MAX_SPEED * delta)
		else:
			$Sprite.flip_h =  false
			velocity.x = max(location.x + ACCELERATION, MAX_SPEED * delta)
	else:
		state = IDLE
			
func roam_state(delta):
	detectPlayer()
	animationState.travel("Walk")
	if roamAI.get_time_left() == 0:
		state = pick_random_state([IDLE, ROAM])
		roamAI.start_roaming_timer(rand_range(1,3))
	
	#var location = global_position.direction_to(roamAI.target_position.x)
	#velocity.x = max(location.x + ACCELERATION, MAX_SPEED * delta)

func takehit_finished():
	state = IDLE
