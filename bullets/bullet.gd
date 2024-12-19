extends RigidBody2D

@export var particles: PackedScene
@export var damageAmt = 10
@export var speed = 400

var maxHits = 1
var hits = 0

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(position_: Vector2, direction: Vector2):
	position = position_
	set_linear_velocity(speed * direction)
	
func hit():
	hits += 1
	if hits >= maxHits:
		queue_free()
		

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
	gravity_scale = 0
	contact_monitor = true
	max_contacts_reported = 1
	
func _physics_process(delta: float) -> void:
	if get_contact_count() > 0:
		queue_free()

# ========================
# ====== RECIEVERS =======
# ========================

func _on_despawn_timer_timeout():
	queue_free()
