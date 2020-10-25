extends Node

export(int) var MAX_DAMAGE = 1
onready var damage =  MAX_DAMAGE

export(int) var MAX_HEALTH = 1
onready var health =  MAX_HEALTH setget _set_health

signal no_health

func _set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")


