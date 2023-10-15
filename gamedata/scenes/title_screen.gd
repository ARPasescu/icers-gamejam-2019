extends Control

onready var anim_player = get_node("AnimationPlayer")

func _ready():
	if not get_tree().get_root().get_child_count() == 1:
		self.modulate = Color(1,1,1,0)

func show_title_screen():
	play_animation(1)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")

func _on_play_button_button_up():
	play_animation(0)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")
	
	var game_scene = load("res://gamedata/scenes/game_scene.tscn").instance()
	get_tree().get_root().add_child(game_scene)
	self.connect("tree_exited", game_scene, "start_game")
	self.queue_free()

func _on_instructions_button_button_up():
	play_animation(0)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")
	
	var instructions = load("res://gamedata/scenes/instructions_screen.tscn").instance()
	get_tree().get_root().add_child(instructions)
	self.connect("tree_exited", instructions, "show_instructions_screen")
	self.queue_free()

func _on_quit_button_button_up():
	get_tree().quit()

func play_animation(track_enabled):
	var dissolve_anim = load("res://gamedata/assets/Dissolve.anim")
	dissolve_anim.track_set_enabled(track_enabled, true)
	anim_player.add_animation("Dissolve", dissolve_anim)
	anim_player.play("Dissolve")

func _on_LinkButton_button_up():
	OS.shell_open(get_node("skybox_asset_credits/skybox_link").text)
