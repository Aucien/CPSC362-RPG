extends Area2D

export(String, FILE, "*.tscn") var next_world
export (int) var current_hp

onready var animationPlayer = $AnimationPlayer
onready var animationState = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "HeroKnight":
			animationPlayer.play("Screen_Transition_Fadein")
			yield(animationPlayer, "animation_finished")
			get_tree().change_scene(next_world)

#func _on_Exit_body_entered(body):
#	if next_world:
#		get_node("/root/GlobalSave").player_hp = current_hp
