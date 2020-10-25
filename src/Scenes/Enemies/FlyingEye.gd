extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0,-1)

var velocity = Vector2()

var direction = 1

var state = IDLE

enum {
	IDLE,
	TAKE_HIT,
	DEATH
}
var hp = 1

func _ready():
	pass
	
func flying(delta):
	$Sprite.play("Flying")

func take_hit(delta):
	$Sprite.play("Damage")
	
func dead(delta):
	velocity = Vector2(0,0)
	$Sprite.play("Death")

	
func _physics_process(delta):
	
		velocity.x = SPEED * direction
		
		if direction == 1:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
			
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)
	
	
		if is_on_wall():
			direction = direction * -1
		#$RayCast2D.position.x *= -1

	#if $RayCast2D.is_colliding() == false:
		#direction = direction* -1
		#$RayCast2D.position.x *= -1
		match state:
			IDLE:
				flying(delta)
			TAKE_HIT:
				take_hit(delta)
			DEATH:
				dead(delta)

		if hp <= 0:
			state = DEATH
			velocity = Vector2(0,0)
func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox":
		hp -= area.damage
		state = TAKE_HIT
		print(hp)
		
		
