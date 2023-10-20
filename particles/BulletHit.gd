extends CPUParticles2D

func initialize(sourcePos, dir):
	position = sourcePos
	look_at(dir)

func _on_despawn_timer_timeout():
	queue_free()
