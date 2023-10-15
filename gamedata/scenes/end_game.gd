extends Control

onready var anim_player = get_node("AnimationPlayer")

var scenario = ""

func show_end():
	self.modulate = Color(1,1,1,0)
	match scenario:
		"win":
			get_node("win_text").visible = true
			get_node("win_color").visible = true
		"lose_time":
			get_node("lose_time_text").visible = true
			get_node("lose_color").visible = true
		"lose_health":
			get_node("lose_health_text").visible = true
			get_node("lose_color").visible = true
		
	play_animation(1)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")
	

func _on_replay_button_button_up():
	
	play_animation(0)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")
	
	var game_scene = load("res://gamedata/scenes/game_scene.tscn").instance()
	get_tree().get_root().add_child(game_scene)
	self.connect("tree_exited", game_scene, "start_game")
	self.queue_free()

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