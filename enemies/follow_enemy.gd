extends CharacterBody2D

var mainNode: Node
var playerNode: CharacterBody2D
var particlesNode: Node

var t = 0
var health = 50
var speed = 80

# ========================
# ==== CUSTOM METHODS ====
# ========================

func damage(amt):
	health -= amt
	
	if health <= 0:
		queue_free()

func initialize(startPosition: Vector2, player: CharacterBody2D):
	position = startPosition
	playerNode = player

# ========================
# ===== NODE METHODS =====
# ========================
	
func _process(delta):
	t += delta
	
	if playerNode:
		var displacement = playerNode.position - position
		# TODO: replace with move_and_slide
		position = position + delta * speed * displacement.normalized()

func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player_bullets"):
		damage(body.damage_amt)
		body.queue_free()
	elif body.is_in_group("player"):
		body.damage(10)
		queue_free()
