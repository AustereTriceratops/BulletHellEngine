extends CharacterBody2D

@export var particles: PackedScene
@export var creatureName = 'unknown'
@export var health = 50
@export var speed = 80
@export var pointValue = 1
@export var bullet_speed = 0
@export var rangeDamage = 0
@export var contactDamage = 5
@export var isAggressive = false
@export var aggressionRange = 400
@export var meleeInterval = 0.6

@onready var hitFlash = $HitFlash
@onready var mainNode = get_tree().get_root().get_node("Level")

#var mainNode: Node
var playerNode: CharacterBody2D
var meleeBody: CharacterBody2D
var t = 0

# ========================
# ==== CUSTOM METHODS ====
# ========================

func damage(amt):
	health -= amt
	hitFlash.play('hit_flash')
	
	if health <= 0:
		mainNode.enemy_died(self)
		queue_free()

func initialize(startPosition: Vector2, player: CharacterBody2D):
	position = startPosition
	playerNode = player

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	$MeleeTimer.wait_time = meleeInterval
	
func _process(delta):
	t += delta
	
	if playerNode && is_instance_valid(playerNode):
		var displacement = playerNode.position - position
		var distance = displacement.length()
		
		if distance < aggressionRange:
			isAggressive = true
		
		if isAggressive:
			# TODO: replace with move_and_slide
			position = position + delta * speed * displacement.normalized()
			look_at(playerNode.position)


func _on_hitbox_body_entered(body: Node2D):
	if body.is_in_group("player_bullets"):
		damage(body.damage_amt)
		isAggressive = true
		body.queue_free()
	elif body.is_in_group("player"):
		$MeleeTimer.start()
		meleeBody = body
		meleeBody.damage(contactDamage)
		#queue_free()


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		$MeleeTimer.stop()
		meleeBody = null


func _on_melee_timer_timeout() -> void:
	meleeBody.damage(contactDamage)
