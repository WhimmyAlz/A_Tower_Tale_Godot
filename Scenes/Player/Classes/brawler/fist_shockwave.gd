extends Area2D

var speed := Vector2(0, 0)
var size := 2
var lifetime := 10
var dir := Global.player_dir

var player

func set_speed(x, y):
	speed = Vector2(x * dir, y)

func set_pos(pos):
	position = pos

func set_player(ply):
	player = ply

func set_lifetime(time):
	lifetime = time

func _ready() -> void:
	self.scale.x = size
	self.scale.y = size

func _physics_process(_delta: float) -> void:
	if dir == -1:
		$AnimatedSprite2D.flip_h = true
	elif dir == 1:
		$AnimatedSprite2D.flip_h = false
		
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	
	var collider = body
	if collider.is_in_group("attackable") and collider.is_in_group("enemy"):
		collider.take_damage(5)
		collider.take_knockback(10, dir)
		collider.take_stun(20)
