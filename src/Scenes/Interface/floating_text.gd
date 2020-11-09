extends Position2D

onready var label = $Rotation/Label
onready var tween = $Tween
var amount = 0

var velocity = Vector2(0,0);

func _ready():
	label.set_text(str(amount))
	velocity.y = 25
	if self.global_scale.y == -1:
		tween.interpolate_property(self, 'scale', scale, Vector2(-1,1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(self, 'scale', Vector2(-1,1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	else:
		tween.interpolate_property(self, 'scale', scale, Vector2(1,1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(self, 'scale', Vector2(1,1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()

func _process(delta):
	position -= velocity * delta
