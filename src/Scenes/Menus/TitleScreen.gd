extends Control

#onready var animationPlayer = $AnimationPlayer

func _ready():
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "on_ButtonPressed", [button.scene_to_load])

func on_ButtonPressed(scene_to_load):
	get_tree().change_scene("res://src/Scenes/World/World.tscn")

