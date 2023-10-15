extends Area2D

onready var player = get_parent().get_parent().get_node("player")
onready var progress_bar = get_node("ProgressBar")
onready var game_scene = get_parent().get_parent()

const discovery_multiplier = 20

var found = false

func _process(delta):
	if overlaps_body(player):
		if Input.is_action_pressed("ui_select"):
			progress_bar.visible = true
			if progress_bar.value < 100:
				progress_bar.value += discovery_multiplier * delta
			else:
				self.visible = false
				if not found:
					game_scene.artifacts_found += 1
					found = true
		else:
			progress_bar.value = 0
			progress_bar.visible = false
	else:
		progress_bar.visible = false