extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0
var buttonTouching = ""
var fileTouching = ""
var isTouchingTrash = false
var fileHolding = ""
var moving
var areasColliding
signal taskCompleted
signal death
func _physics_process(delta):
	position = Vector2(clamp(position.x, 0, 1920),clamp(position.y, 0, 1080))
	areasColliding = $Area2D.get_overlapping_areas()
	if areasColliding.size() > 0:
		if areasColliding[0].get_parent() is Button:
			buttonTouching = areasColliding[0]
		elif areasColliding[0].is_in_group("isFile"):
			fileTouching = areasColliding[0]
		else:
			isTouchingTrash = true
	else:
		buttonTouching = ""
		fileTouching = ""
		isTouchingTrash = false
	if Input.is_action_just_pressed("ui_accept"):
		if str(fileHolding) != "":
			var child_node = fileHolding
			remove_child(child_node)
			if isTouchingTrash:
				emit_signal("taskCompleted")
				$trash.play()
			else:
				get_tree().get_root().add_child(child_node)
				child_node.position = Vector2(global_position.x, global_position.y - 50)
				child_node.rotation = 0
			fileHolding = ""
		elif str(buttonTouching) != "" and buttonTouching.is_visible_in_tree() and buttonTouching.is_in_group("isButton"):
			buttonTouching.get_parent().pressed.emit()
			$click.play()
		elif str(fileTouching) != "" and str(fileHolding) == "":
			var child_node = fileTouching.get_parent()
			child_node.position = Vector2(0,-100)
			child_node.rotation = 0
			if child_node.get_parent():
				child_node.get_parent().remove_child(child_node)
			add_child(child_node)
			fileHolding = child_node
			$paper.play()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	if directionX:
		velocity.x = directionX * SPEED * delta * 60
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if directionY:
		velocity.y = directionY * SPEED * delta * 60
		$AnimatedSprite2D.play()
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if not directionX and not directionY:
		$AnimatedSprite2D.stop()
		
	$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation, atan2(velocity.x, -velocity.y), delta*100)
	if velocity != Vector2(0,0) and !$AudioStreamPlayer2D.is_playing():
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.95, 1.05)
		$AudioStreamPlayer2D.play()
	move_and_slide()


func _on_area_2d_body_entered(body):
	if !body.is_in_group("player"):
		emit_signal("death")
