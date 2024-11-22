extends CPUParticles2D

func initialize(sourcePos):
	position = sourcePos

func _on_despawn_timer_timeout():
	queue_free()
