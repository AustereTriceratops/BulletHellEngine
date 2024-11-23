extends Node

@export var healthPickupScene: PackedScene

var rng = RandomNumberGenerator.new()

func spawn_pickup(pos):
	var r = rng.randf()
	
	if r < 0.4:
		var healthPickup = healthPickupScene.instantiate()
		healthPickup.position = Vector2(pos.x, pos.y)
		call_deferred("add_child", healthPickup)
