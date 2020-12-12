extends Control

export(String, FILE, "*.tscn") var next_world
export (int) var current_hp


var level_thread = Thread.new()
var load_percent = 0
		
func _ready():
	loadgame()
	
func loadgame():
	level_thread.start(self, "build_level", null, 1)
	setup_()

func setup_():
	load_percent += 50
	percent_update(load_percent)
	
func build_level(empty):
	load_percent += 50
	percent_update(load_percent)
	level_thread.wait_to_finish()

func percent_update(new_percent):
	$Tween.interpolate_property($ProgressBar, "value", $ProgressBar.value, new_percent, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	if new_percent == $ProgressBar.max_value:
		$AnimationPlayer.play("Loading")
		yield($AnimationPlayer, "animation_finished")
		get_tree().change_scene(next_world)
