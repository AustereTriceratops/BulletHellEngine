extends RigidBody2D

@export var particles: PackedScene
@export var damageAmt = 10

var maxHits = 1
var hits = 0
var bulletType = null

# ========================
# ==== CUSTOM METHODS ====
# ========================

func initialize(position_: Vector2, velocity_: Vector2):
    position = position_
    set_linear_velocity(velocity_)
    
func hit():
    hits += 1
    if hits >= maxHits:
        queue_free()

func setType(bulletType_: String):
    bulletType = bulletType_
    
    if bulletType == "blue":
        set_modulate(Color(0.278, 0.694, 0.714))
    elif bulletType == "red":
        set_modulate(Color(0.754, 0.295, 0.418))
    elif bulletType == "green":
        set_modulate(Color(0.447, 0.745, 0.424))
    

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
