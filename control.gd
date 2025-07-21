extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	$startMenu.visible = !$startMenu.visible


func _on_file_button_pressed():
	$settingsWindow.show()



func _on_email_button_pressed():
	$emailWindow.show()


func _on_power_button_pressed():
	pass


func _on_close_button_pressed():
	$emailWindow.hide()
	$emailWindow/ColorRect/emailBox.hide()


func _on_compose_button_pressed():
	$emailWindow/ColorRect/emailBox.show()


func _on_wallpaper_button_pressed():
	$settingsWindow/ColorRect/buttons.hide()
	$settingsWindow/ColorRect/wallpaper.show()


func _on_back_button_pressed():
	$settingsWindow/ColorRect/buttons.show()
	$settingsWindow/ColorRect/wallpaper.hide()
