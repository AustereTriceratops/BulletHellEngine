extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(_event):
	if Input.is_action_just_pressed('pause'):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
