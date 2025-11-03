extends Node2D

@export var bulletScene: PackedScene = preload('res://bullets/TypedBullet.tscn')

@onready var mainNode = get_tree().get_root().get_node('Level')
@onready var bulletsNode

var bulletDamage = 20
var bulletSpeed = 800

var count = 0

func _on_long_timer_timeout() -> void:
    $ShortTimer.start()


func _on_short_timer_timeout() -> void:
    spawn_bullet()
    
    count += 1
    
    if count > 2:
        $ShortTimer.stop()
        count = 0
    

func spawn_bullet():
    
    var bulletType
    if count == 0:
        bulletType = "blue"
    elif count == 1:
        bulletType = "red"
    elif count == 2:
        bulletType = "green"
        
    
    var bulletVelocity = bulletSpeed * global_transform.y
    
    for i in range(100):
        var bullet = bulletScene.instantiate()
        bullet.setType(bulletType)
        bullet.damageAmt = bulletDamage
        var bulletPosition = position + 40*(i - 50) * global_transform.x
        bullet.initialize(bulletPosition, bulletVelocity)
        
        bulletsNode.add_child(bullet)

func _ready():
    mainNode.ready.connect(_on_main_ready)

func _on_main_ready():
    bulletsNode = mainNode.get_node("Enemies/EnemyBullets")
    
