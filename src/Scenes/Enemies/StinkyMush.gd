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

onready var stats = $Stats
onready var hp = stats.health
onready var playerDetectionZone = $PlayerDectection
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
			attack_state()
		ROAM:
			pass

	velocity = move_and_slide(velocity)
	
func detectPlayer():
	if playerDetectionZone.detected():
		state = CHASE

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

func take_hit(delta):
	animationState.travel("Take_Hit")
	
func death_state(delta):
	velocity.x = 0
	animationState.travel("Death")
	
func chase_state(delta):
	var player = playerDetectionZone.player
	if player != null:
		var location = (player.global_position  - global_position).normalized()
		animationState.travel("Run")
		if player.global_scale.y == 1:
			$Sprite.flip_h = true
			velocity.x = -max(location.x + ACCELERATION, MAX_SPEED * delta)
			#state = ATTACK
		else:
			$Sprite.flip_h = false
			velocity.x = max(location.x + ACCELERATION, MAX_SPEED * delta)
	else:
		state = IDLE
			
func roam_state():
	pass

func attack_state():
	animationState.travel("Attack")

func takehit_finished():
	state = IDLE
