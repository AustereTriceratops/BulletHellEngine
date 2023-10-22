extends Control

signal resume()
signal show_options()
signal quit()

func _on_resume_pressed():
	resume.emit()


func _on_options_pressed():
	show_options.emit()


func _on_quit_pressed():
	quit.emit()
