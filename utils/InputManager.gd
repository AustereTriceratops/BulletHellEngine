extends Node

@onready var mainNode = get_tree().get_root().get_node('Level')

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_event):
	if Input.is_action_just_pressed('pause'):
		if mainNode.paused:
			mainNode.resume()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mainNode.pause()
