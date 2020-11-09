extends Area2D

export(int) var MAX_DAMAGE =  1 setget set_damage
onready var damage =  MAX_DAMAGE

func set_damage(value):
	MAX_DAMAGE = value


