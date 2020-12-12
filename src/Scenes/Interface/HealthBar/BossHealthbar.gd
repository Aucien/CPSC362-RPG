extends Control

onready var health_bar = $Healthbar

func _process(delta):
	health_bar.value = GlobalSave.boss_health

