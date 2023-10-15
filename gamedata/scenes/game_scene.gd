extends Control

onready var timer = get_node("timer")
onready var time_label = get_node("UI_layer/UI/time")
onready var anim_player = get_node("AnimationPlayer")
onready var player = get_node("player")
onready var air_bar = get_node("UI_layer/UI/air_bar")
onready var hp_bar = get_node("UI_layer/UI/health_bar")
onready var artifact_count = get_node("UI_layer/UI/artifacts_label/artifact_count")
onready var win_notifier = get_node("UI_layer/UI/win_notifier")

var is_game_ended = false
var artifacts_found = 0
var artifacts_total = 6

func _ready():
	self.modulate = Color(1,1,1,0)

func start_game():
	play_animation(1)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")

func _process(delta):
	
	if not is_game_ended:
		if not timer.is_stopped():
			var time_left = int(timer.time_left)
			var seconds = time_left % 60
			var minutes = time_left / 60
			time_label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
			
			if time_left <= 30:
				if timer.time_left - time_left > 0.5:
					time_label.add_color_override("font_color", Color(255, 0, 0, 255))
				else:
					time_label.add_color_override("font_color", Color(255, 255, 255, 255))
		else:
			end_game("lose_time")
	
		hp_bar.value = player.hp
		air_bar.value = player.air
		artifact_count.text = str(artifacts_found) + " / " + str(artifacts_total)
	
		if player.hp <= 0:
			end_game("lose_health")
		elif artifacts_found == artifacts_total:
			if player.position.y < 1020:
				end_game("win")
			else:
				if timer.time_left - int(timer.time_left) > 0.5:
					win_notifier.visible = true
					win_notifier.add_color_override("font_color", Color(0, 255, 0, 255))
				else:
					win_notifier.add_color_override("font_color", Color(255, 255, 255, 255))
	

func end_game(scenario):
	is_game_ended = true
	get_node("UI_layer/UI").visible = false
	timer.stop()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	timer.start()
	yield(timer, "timeout")
	
	play_animation(0)
	yield(anim_player, "animation_finished")
	anim_player.remove_animation("Dissolve")
	
	var endgame_screen = load("res://gamedata/scenes/end_game.tscn").instance()
	get_tree().get_root().add_child(endgame_screen)
	endgame_screen.scenario = scenario
	
	self.connect("tree_exited", endgame_screen, "show_end")
	self.queue_free()
	
func play_animation(track_enabled):
	var dissolve_anim = load("res://gamedata/assets/Dissolve.anim")
	dissolve_anim.track_set_enabled(track_enabled, true)
	anim_player.add_animation("Dissolve", dissolve_anim)
	anim_player.play("Dissolve")