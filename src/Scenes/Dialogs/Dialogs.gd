extends Control

func on_ButtonPressed(scene_to_load):
	get_tree().change_scene(scene_to_load)

		
func _ready():
	$SkipButton.connect("pressed", self, "on_ButtonPressed", [$SkipButton.scene_to_load])
