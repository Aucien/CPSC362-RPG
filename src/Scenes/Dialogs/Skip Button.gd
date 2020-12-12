extends Button

export(String, FILE, "*.tscn") var scene_to_load


func _process(delta):
	if Input.is_action_just_pressed("left_mouse"):
		$Click.play()

