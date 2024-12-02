extends Control

@onready var mainNode = get_tree().get_root().get_node("Level")

func _on_resume_pressed():
	mainNode.resume()


func _on_options_pressed():
	mainNode.options()


func _on_quit_pressed():
	mainNode.quit()
