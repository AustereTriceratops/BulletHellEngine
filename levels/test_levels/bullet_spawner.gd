extends Node2D

@export var bulletScene: PackedScene = preload('res://bullets/TypedBullet.tscn')

@onready var mainNode = get_tree().get_root().get_node('Level')
@onready var bulletsNode

var active = false
var bulletDamage = 20
var bulletSpeed = 800

var count = 0
var t = 0
var t0 = 1.2
var t1 = 3

func spawn_bullets(delta):
    if (count < 3) and (t + delta > t0):
        var bulletType
        
        if count == 0:
            bulletType = "red"
        elif count == 1:
            bulletType = "blue"
        elif count == 2:
            bulletType = "green"
        
        var bulletVelocity = bulletSpeed * global_transform.y
        var fac = Math.modulo_float(t + delta, t0)
        var deltaPosition = fac * bulletVelocity
        
        for i in range(100):
            var bullet = bulletScene.instantiate()
            bullet.setType(bulletType)
            bullet.damageAmt = bulletDamage
            var bulletPosition = position + deltaPosition + 40*(i - 50) * global_transform.x
            bullet.initialize(bulletPosition, bulletVelocity)
        
            bulletsNode.add_child(bullet)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
    mainNode.ready.connect(_on_main_ready)

func _process(delta):
    if !active:
        return
    
    if is_instance_valid(bulletsNode):
        spawn_bullets(delta)
    
    t += delta;
    
    if (count > 2) and (t > t1):
        t = Math.modulo_float(t, t1)
        count = 0
    elif (count < 3) and (t > t0):
        t = Math.modulo_float(t, t0)
        count += 1
    
# ========================
# ====== RECIEVERS =======
# ========================

func _on_main_ready():
    bulletsNode = mainNode.get_node("Enemies/EnemyBullets")
    
