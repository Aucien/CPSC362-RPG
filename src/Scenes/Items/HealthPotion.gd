extends Area2D

onready var animationPlayer = $AnimationPlayer
onready var animationState = $AnimationTree.get("parameters/playback")
	
func vanish():
	queue_free()

func _on_HealthPotion_body_entered(body):
	if body.name == "HeroKnight":
		animationPlayer.play("Use")
		vanish()
