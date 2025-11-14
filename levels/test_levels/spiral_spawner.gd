extends Node2D

@export var bulletScene: PackedScene = preload('res://bullets/TypedBullet.tscn')

@onready var mainNode = get_tree().get_root().get_node('Level')
@onready var bulletsNode

@export var clockwise = true
@export var active = true
@export var numBullets = 2
@export var bulletDamage = 10
@export var bulletSpeed = 600

var allied = false

var t = 0


# numBullets determines how many bullets will be shot out from all directions
func spawn_spiral_pattern(
    delta: float, numBullets=1, cycleTime=6.0, numShots=30
):
    var shotOrientation = 1 if clockwise else -1
    var shotInterval = cycleTime/numShots 
    # amount of time since the last shot
    var frac = Math.modulo_float(t, shotInterval) 
    # total time since the last shot
    var timeSinceLastShot = frac + delta
    
    var n_hist = floor(t/shotInterval) # number of shots that have already fired in the pattern
    var n = floor(timeSinceLastShot/shotInterval) # number of shots to perform
    
    for i in range(n):
        # these bullets will spawn with n-fold symmetry
        for j in range(numBullets):
            var bullet
            
            if allied:
                pass
                #bullet = playerBulletScene.instantiate()
            else:
                bullet = bulletScene.instantiate()
    
            bulletsNode.add_child(bullet)
            
            var bulletDirection = Vector2(1.0, 0.0).rotated(
                2 * PI * shotOrientation * ((n_hist/numShots) + float(j)/numBullets)
            )
            
            var deltaPosition = bulletSpeed * (timeSinceLastShot - i*shotInterval) * bulletDirection
            bullet.initialize(position + deltaPosition, bulletSpeed * bulletDirection)

# ========================
# ===== NODE METHODS =====
# ========================

func _ready():
    mainNode.ready.connect(_on_main_ready)

func _process(delta):
    if !active:
        return
    
    if is_instance_valid(bulletsNode):
        spawn_spiral_pattern(delta, numBullets, 6.0, 30)
    
    t += delta;
    
# ========================
# ====== RECIEVERS =======
# ========================

func _on_main_ready():
    bulletsNode = mainNode.get_node("Enemies/EnemyBullets")
    
