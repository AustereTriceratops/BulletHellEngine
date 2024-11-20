extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart_pressed():
	get_tree().change_scene_to_file('res://levels/BulletHeavenTest.tscn')

func _on_main_menu_pressed():
	get_tree().change_scene_to_file('res://ui/StartMenu.tscn')
