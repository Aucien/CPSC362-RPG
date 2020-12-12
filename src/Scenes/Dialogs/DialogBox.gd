extends Control

var dialog = [
	'It was a dark night, one of those in which the moon does not dare showing her face strange noises wereheard inside the royal palace, candlelight trembled, and dogs barked',
	'A scream of terror, and the princess was gone, only her diadem and a shredded piece of her gown remained on her chambers',
	'The princess was kind and loved by her people, no one knew who had been capable of such a crime',
	'Some servants claimed to have seen a group of strange creatures whose description infused dread into the souls of those who heard it, roaming the palace on that cursed night.'
]

var dialog_index = 0
var finished = false

export(String, FILE, "*.tscn") var scene_to_load

func _read():
	return
	load_dialog()
	
func _process(delta):
	$Indicator.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		#load_dialog()
		call_deferred("play_dialog")
	return
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


func _ready():
	play_dialog()


func play_dialog():
	var dialog_object = DialogGlobal.dialogs_list[DialogGlobal.dialog_index]
	get_parent().get_node("Background").texture = dialog_object.get_background()
	var dialog_dictionary = dialog_object.get_dialog()
	if not dialog_dictionary:
		if not DialogGlobal.next_index():
			if DialogGlobal.dialog_index == DialogGlobal.dialogs_list.size() - 1:
				DialogGlobal.dialog_index  = 0
				scene_to_load = "res://src/Scenes/Menus/LoadingNewWorld.tscn"
			else:
				scene_to_load = DialogGlobal.next_scene
			get_tree().change_scene(scene_to_load)
		else:
			play_dialog()
	else:
		finished = false
		$SpeakerTexture.texture = dialog_dictionary.speaker_texture
		$Speaker.text = dialog_dictionary.speaker
		$RichTextLabel.bbcode_text = dialog_dictionary.message
		$RichTextLabel.percent_visible = 0 
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0,1,1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
