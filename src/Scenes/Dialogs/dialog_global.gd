extends Node

var flip_sfx = preload("res://Assets/Audio/Page Turning Sfx.wav")
var audio_player
var dialog_index = 0
var dialogs_list = []
var next_scene
var dialogs = {
	"Intro": [
		"Welcome to Heroic Journey. Here you will be introduced to the Hero Fantasy world where his journey takes place. Let us start the story. Please press Enter to continue…",
		'It was a dark night, one of those in which the moon does not dare showing her face, some strange noises wereheard inside the royal palace, candlelight trembled, and dogs barked',
		'A scream of terror, and the princess was gone, only her diadem and a shredded piece of her gown remained on her chambers',
		'The princess was kind and loved by her people, no one knew who had been capable of such a crime',
		'Some servants claimed to have seen a group of strange creatures whose description infused dread into the souls of those who heard it, roaming the palace on that cursed night.'
	],
	"The Hero": [
		'When the princess was kidnapped by those wicked creatures, sadness and fear overrun the hearts of everyone in the court of the king, everyone was paralyzed by terror',
		'All but one, the bravest knight in the court stood up, and valiantly offered himself to go on a quest to find and rescue the princess',
		'The king, constricted by grief, granted this courageous knight his blessing and bid him farewell.',
		'Thus, carrying his mighty sword and the noble shield of his house, eyes filled with brave hope, he set on his journey accompanied by the cheers of the crowd, unaware of the perils that awaited ahead',
	],
	"Skeleton Warriors": [
		'After the hero knight prepared for his journey, the knight went on walking in search for the source of this new found evil',
		'He eventually passed by a graveyard, strewn with tombstones of long-forgotten warriors, whose names had been erased from the rock by the passing of centuries',
		'He had learnt of the dangers from above, but was oblivious to the ones below ground, cautiously walking he was when something stirred the earth beneath his feet',
		'One by one, the dead rose from their graves, once righteous warriors from ancient times, they were now slaves to the evil mysterious power that brought them back to life',
		'They attacked our hero with no hesitation, thus he prepared to face danger once more',
	],
	"Mushroom Monster": [
		'The land had become stranger the further our brave hero went',
		'Now everything looked unfamiliar and threatening',
		'Suddenly a new creature appeared, its shape resembled a giant mushroom, with a merciless face and a bloodlust expression',
		'Its mushroom-like head was surrounded by a cloud of ill-looking spores that waved as the creature threw itself upon our brave warrior, who avoided the attack and turned to face this new foe'
	],
	"Goblin Bandit": [
		'Our tireless warrior continued his journey among ever more desolate surroundings',
		'He was traversing this ghostly world when a goblin bandit jumped off the bushes, this cunning creatures were twisted and unscrupulous',
		'He was covered with a ragged leather armor and carried a rusty dagger. He attacked with an evil laugh trying to stab the valiant knight'
	],
	"Ending": [
		"Hero: Faris! I’m glad to see you, it has been a while. What are you doing here? ",
		"Villain: Oh, I’m sure you did not expect to see me, did you?",
		"Hero: Are you here to help? You did not need to, I got this",
		"Villain: I would not be so sure about that.",
		"Hero: What do you mean? Are there more foes to face?",
		"Villain: Oh, yes, only one more, since you defeated all of my minions, I had to come down myself. (Magic energy starts to gather around his body)",
		"Hero: What? You are… Wait, what are you doing? I didn’t know you could use magic",
		"Villain: I’ve been learning the magic arts so I could carry out my plan, haha!",
		"Hero: So, it was you who…",
		"Villain: YES! I have always been under your shadow, longing for the beautiful princess’ attentions, I got tired of waiting for her or the king to notice me!",
		"Hero: Under my shadow? I thought we were friends…",
		"Villain: We have never been friends, I learnt dark magic to control the creatures that stole your precious princess, but also, I learnt the dark arts so I could defeat you on this day! (He attacks the hero with magic and the battle starts)",
	],
}


class Dialog:
	var heading
	var background
	var background_path
	var base_folder
	var list
	var index = 0
	
	func setup(heading, list):
		set_heading(heading)
		set_list(list)
		set_base_folder()
		set_background_path()
		set_background()
	
	func set_heading(new_heading):
		heading = new_heading
	
	func get_heading():
		return heading
	
	func set_background():
		background = load(background_path)
	
	func get_background():
		return background
	
	func set_list(dialog_list):
		list = dialog_list
	
	func get_list():
		return list
	
	func set_background_path():
		background_path = base_folder + "background.png"
	
	func get_background_path():
		return background_path
	
	func set_base_folder():
		base_folder = "res://src/Scenes/Dialogs/Data/" + get_folder() + "/"
	
	func get_folder():
		return str(heading).to_lower().replace(" ", "_")
	
	func get_dialog():
		if index >= list.size():
			return false
		else:
			var message = str(list[index])
			var speaker = ""
			var speaker_texture = null
			if message.find(": ") != -1:
				speaker = message.split(": ")[0]
				message = message.split(": ")[1]
			if speaker != "":
				speaker_texture = load(base_folder + speaker + ".png")
			else:
				var file = File.new()
				if file.file_exists(base_folder + heading + ".png"):
					speaker_texture = load(base_folder + heading + ".png")
			if heading.to_lower() == "ending":
				message = speaker + ": " + message
				speaker = ""
				speaker_texture = null
			
			var dialog = {
				"speaker": speaker,
				"speaker_texture": speaker_texture,
				"message": message
			}
			index += 1
			return dialog


func _ready():
	dialog_index = 0
	dialogs_list = []
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = flip_sfx
	add_child(audio_player)
	for key in dialogs.keys():
		var dialog = Dialog.new()
		dialog.setup(key, dialogs[key])
		dialogs_list.append(dialog)


func next_index():
	if dialog_index >= dialogs_list.size() - 1:
		dialog_index += 1
		audio_player.play()
		return false
	elif dialog_index == dialogs_list.size() - 2:
		audio_player.play()
		dialog_index += 1
		return false
	else:
		audio_player.play()
		dialog_index += 1
		return true
