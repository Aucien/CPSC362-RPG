extends Node2D

export(int) var roaming_range = 32

onready var start_position = global_position.x
onready var target_position = global_position.x
onready var timer = $Timer

func position_update():
	var target_x_vector = randi()
	target_position =  start_position + target_x_vector

func get_time_left():
	return timer.time_left
	
func start_roaming_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	position_update()
