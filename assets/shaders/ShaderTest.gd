extends Node2D

func _ready():
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property($Background, "material:shader_parameter/scale", 5, 1)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property($Background, "material:shader_parameter/peak_radius", 0.2, 1)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	tween.tween_property($Background, "material:shader_parameter/cutoff", 1.6, 1)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
