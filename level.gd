extends Node2D
var taskOneProgress = 0
var taskOneCompleted = false
var taskTwoCompleted = false
var taskThreeCompleted = false
var allTasksCompleted = false
var children
var playerPosition
var wallpaper1 = [load("res://Sprites/wallpapersw/bliss.jpg"), load("res://Sprites/wallpapersw/blisscompressed.jpg")]
var wallpaper2 = [load("res://Sprites/wallpapersw/painting.jpeg"), load("res://Sprites/wallpapersw/paintingcompressed.jpeg")]
var wallpapers = [wallpaper1, wallpaper2]
var folderNames = ["Free Games","Crypto","Homework","Music","Meemaw's Gravy Recipe","Memes","Movies","Tax Returns"]
var rng = RandomNumberGenerator.new()
var folderNum = randi_range(1,folderNames.size())
var brightnessNum = randi_range(1,9) * 10
# Called when the node enters the scene tree for the first time.
func _ready():
	$start.play()
	$tasks/score.text = str(Global.score)
	randomize()
	children = get_all_children(self)
	$Control/taskbar.color = Color(randf_range(0,0.9),randf_range(0,0.9),randf_range(0,0.9),1)
	$Control/startMenu.color = $Control/taskbar.color
	# Randomize Folders
	for i in folderNum:
		var randChosen = randi_range(0,(folderNum)-i)
		var f = File.new_file(folderNames[randChosen-1])
		if folderNames[randChosen-1] == folderNames[folderNames.size()-1]:
			folderNames.erase(folderNames[folderNames.size()-1])
		else:
			folderNames.remove_at(randChosen-1)
		add_child(f)
	$tasks/time/deathTimer.wait_time = folderNum * 6.5 + 10
	$tasks/time/deathTimer.start()
	$tasks/taskOne.text = "DELETE IMPORTANT FILES (" + str(taskOneProgress) + "/" + str(folderNum) + ")"
	# Randomize Wallpaper
	wallpapers.shuffle()
	$wallpaper.texture = wallpapers[0][0]
	$Control/settingsWindow/ColorRect/wallpaper/wallpaper1.icon = wallpapers[0][1]
	$Control/settingsWindow/ColorRect/wallpaper/wallpaper2.icon = wallpapers[1][1]
	# Randomize Brightness
	$tasks/taskThree.text = "LOWER BRIGHTNESS TO " + str(brightnessNum) +"%"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("openTask"):
		$tasks.visible = !$tasks.visible
	for node in children:
		if node is Area2D:
			node.set_collision_layer_value(1, node.is_visible_in_tree())
	playerPosition = $CharacterBody2D.position
			


func _on_character_body_2d_task_completed():
	taskOneProgress += 1
	$tasks/taskOne.text = "DELETE IMPORTANT FILES (" + str(taskOneProgress) + "/" + str(folderNum) + ")"
	if taskOneProgress >= folderNum:
		$success.play()
		taskOneCompleted = true
		if taskOneCompleted and taskTwoCompleted and taskThreeCompleted:
			allTasksCompleted = true
		$tasks/taskOne.set("theme_override_colors/font_color", Color(0,0.8,0,1))


func _on_attachment_button_pressed():
	if allTasksCompleted:
		Global.score += 1
		get_tree().reload_current_scene()


func _on_wallpaper_2_pressed():
	$wallpaper.texture = wallpapers[1][0]
	taskTwoCompleted = true
	$success.play()
	if taskOneCompleted and taskTwoCompleted and taskThreeCompleted:
		allTasksCompleted = true
	$tasks/taskTwo.set("theme_override_colors/font_color", Color(0,0.8,0,1))


func _on_wallpaper_1_pressed():
	$wallpaper.texture = wallpapers[0][0]
	taskTwoCompleted = false
	allTasksCompleted = false
	$tasks/taskTwo.set("theme_override_colors/font_color", Color(0.5,0.5,0.5,1))

func get_all_children(node) -> Array:
	var nodes : Array = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			nodes.append(N)
			nodes.append_array(get_all_children(N))
		else:
			nodes.append(N)
	return nodes


func _on_close_button_2_pressed():
	$Control/settingsWindow.hide()


func _on_minus_button_pressed():
	$CanvasLayer/brightness.color.a += 0.1
	if $CanvasLayer/brightness.color.a >= (100.0 - brightnessNum)/100.0:
		$success.play()
		taskThreeCompleted = true
		$tasks/taskThree.set("theme_override_colors/font_color", Color(0,0.8,0,1))
		if taskOneCompleted and taskTwoCompleted and taskThreeCompleted:
			allTasksCompleted = true
	$Control/settingsWindow/ColorRect/buttons/brightness.text = "BRIGHTNESS - " + str(int(	clamp	(round(100 - $CanvasLayer/brightness.color.a * 100) , 0, 100) ) ) + "%"


func _on_plus_button_pressed():
	$CanvasLayer/brightness.color.a -= 0.1
	$Control/settingsWindow/ColorRect/buttons/brightness.text = "BRIGHTNESS - " + str(int (clamp	(round(100 - $CanvasLayer/brightness.color.a * 100) , 0, 100) ) ) + "%"


func _on_death_timer_timeout():
	get_tree().change_scene_to_file("res://endScreen.tscn")


func _on_character_body_2d_death():
	Global.brutalDeath = true
	get_tree().change_scene_to_file("res://endScreen.tscn")
