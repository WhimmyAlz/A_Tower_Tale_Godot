extends Area2D

var speed := Vector2(0, 0)
var size := 2.5
var lifetime := 10
var direction := Global.player_dir
var angle = 0

var hitnum = 1
var damage = 15
var knockback = 15
var knockbackY = 0
var stuntime = 20

var player

func set_speed(x, y):
	speed = Vector2(x * direction, y)

func set_size(sz):
	size = sz

func set_pos(pos):
	position = pos

func set_pos_x(pos):
	position.x = pos

func set_pos_y(pos):
	position.y = pos

func set_player(ply):
	player = ply

func set_damage(dmg):
	damage = dmg

func set_direction(dir):
	direction = dir

func set_knockback(kb):
	knockback = kb

func set_knockbackY(kb):
	knockbackY = kb

func set_stuntime(stun_t):
	stuntime = stun_t

func set_lifetime(time):
	lifetime = time

func set_angle(value):
	angle = value

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	self.position += speed
	self.rotation = angle
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
		
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	
	var collider = body
	if collider.is_in_group("attackable") and collider.is_in_group("enemy") and hitnum >= 1:
		collider.take_damage(damage)
		collider.take_knockback(knockback, direction)
		collider.take_knockbackY(knockbackY)
		collider.take_stun(stuntime)
		hitnum -= 1
