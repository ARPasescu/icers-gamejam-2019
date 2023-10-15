extends Control

onready var anim_player = get_node("AnimationPlayer")

func _ready():
	self.modulate = Color(1,1,1,0)

func show_instructions_screen():
	play_animation(1)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")

func _on_return_button_button_up():
	play_animation(0)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")
	
	var title_screen = load("res://gamedata/scenes/title_screen.tscn").instance()
	get_tree().get_root().add_child(title_screen)
	
	self.connect("tree_exited", title_screen, "show_title_screen")
	self.queue_free()

func play_animation(track_enabled):
	var dissolve_anim = load("res://gamedata/assets/Dissolve.anim")
	dissolve_anim.track_set_enabled(track_enabled, true)
	anim_player.add_animation("Dissolve", dissolve_anim)
	anim_player.play("Dissolve")