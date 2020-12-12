extends Control

#onready var animationPlayer = $AnimationPlayer

func _ready():
	$GameOver.stop()
	for button in $Menu.get_children():
		button.connect("pressed", self, "on_ButtonPressed", [button.scene_to_load])

func on_ButtonPressed(scene_to_load):
	get_tree().change_scene(scene_to_load)

func _process(delta):
	if Input.is_action_just_pressed("left_mouse"):
		$Click.play()
