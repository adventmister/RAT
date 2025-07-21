extends CharacterBody2D
var isRunning = false
var speed = 300
var aiType = "pause"
var path = [Vector2(0,0), Vector2(0,680), Vector2(1500,680), Vector2(1500,0)]
var index = 0
var stopped = false
var constFrame = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	$head.play()
	path.shuffle()

# Called every frame. 'delta' is the elapsed time since the previous frame. 
func _process(delta):
	$Node.rotation_degrees = 180/PI * asin(sin(PI/10 * $head.frame))
	if index > path.size()-1:
		index = 0
	var playerPosition = get_tree().get_current_scene().playerPosition
	if aiType == "pursue":
		var velocity = (playerPosition - position).normalized()
		position += velocity * speed * delta
		$body.play("crawl")
		$body.speed_scale = constFrame * 3
		if !$crawlFast.is_playing():
			$crawlFast.pitch_scale = randf_range(0.95, 1.05)
			$crawlFast.play()
	elif aiType == "patrol":
		if !$crawl.is_playing():
			$crawl.pitch_scale = randf_range(0.95, 1.05)
			$crawl.play()
		$body.play("crawl")
		$body.speed_scale = constFrame
		if stopped and (abs(position.x) + abs(position.y)) - (abs(path[index].x) + abs(path[index].y)) > 3:
			stopped = false
		var velocity = (path[index] - global_position).normalized()
		position += velocity * speed * delta
		if abs(position - path[index])< Vector2(velocity * speed * delta):
			index += 1
			aiType = "pause"
			$body.stop()
			$head.play("scan")
			print(aiType)
			$pauseTimer.start()
		for i in 3:
			if $Node.get_child(i).get_collider() is CharacterBody2D:
				aiType = "pause"
				$body.stop()
				if !$detect.is_playing():
					$detect.play()
				$head.pause()
	else:
		for i in 3:
			if $Node.get_child(i).get_collider() is CharacterBody2D:
				$body.stop()
				if !$detect.is_playing():
					$detect.play()
				$head.pause()
		
func _on_pause_timer_timeout():
	if aiType == "pause" and !$detect.is_playing():
		aiType = "patrol" 
		$crawl.play()


func _on_detect_finished():
	print("change")
	$body.speed_scale = constFrame * 3
	aiType = "pursue"
	speed = 600
