extends CPUParticles2D

func initialize(sourcePos, direction):
	position = sourcePos
	look_at(direction)

func _on_despawn_timer_timeout():
	queue_free()
