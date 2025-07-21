extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/Label.text = "Score: \n" + str(Global.score)
	if Global.brutalDeath:
		$AudioStreamPlayer.play()
		$ColorRect2.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://level.tscn")


func _on_audio_stream_player_finished():
	print("fade")
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "modulate:a", 0, 1)
	tween.tween_callback($ColorRect2.queue_free)
