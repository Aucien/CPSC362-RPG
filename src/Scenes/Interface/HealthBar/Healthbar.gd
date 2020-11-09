extends Control

onready var health_bar = $Healthbar

#func _on_HeroKnight_health_updated(hp : int) -> void:
	#health_bar.value = GlobalSave.player_hp

func _process(delta):
	health_bar.value = GlobalSave.player_hp
