class_name File

extends Node2D
const my_scene: PackedScene = preload("res://file.tscn")
var fileName: String
var rng = RandomNumberGenerator.new()
var randomNumber = rng.randi_range(0,20)
static func new_file(fileName: String) -> File:
	var new_file: File = my_scene.instantiate()
	new_file.fileName = fileName
	return new_file
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Label.text = fileName
	position = Vector2(randi_range(0,1920), randi_range(0,1080))
	position = Vector2(clamp(position.x, 100, 1820), clamp(position.y, 50, 850))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
