extends Control

var dialog = [
	'It was a dark night, one of those in which the moon does not dare showing her face strange noises wereheard inside the royal palace, candlelight trembled, and dogs barked',
	'A scream of terror, and the princess was gone, only her diadem and a shredded piece of her gown remained in her chambers.',
	'The princess was kind and loved by her people, no one knew who had been capable of such a crime.',
	'Some servants claimed to have seen a group of strange creatures whose description infused dread into the souls of those who heard it, roaming the palace on that cursed night.'
]

var dialog_index = 0
var finished = false
export(String) var scene_to_load

func _read():
	load_dialog()
	
func _process(delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()
	if dialog_index == 5:
		get_tree().change_scene(scene_to_load)
		
func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0 
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0,1,1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		queue_free()
	dialog_index += 1
	
func _on_Tween_tween_completed(object, key):
	finished = true

	
