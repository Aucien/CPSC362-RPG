extends Node

export(int) var MAX_HEALTH = 1
onready var health =  MAX_HEALTH setget _set_health
onready var coin = 1

signal no_health

func _set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
