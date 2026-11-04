extends AnimatedSprite2D

var lifetime = 180
var player = null
var target = null
var damage = 0

@onready var direction = Global.player_dir
var speed

func set_speed(spd):
	speed = Vector2(spd[0] * Global.player_dir, spd[1])

func set_damage(val):
	damage = val

func set_pos(val):
	position = val

func set_player(val):
	player = val

func set_target(val):
	target = val

func _process(_delta: float) -> void:
	lifetime -= 1
	position += speed
	
	if lifetime > 170:
		speed *= 0.915
	
	speed -= Vector2(direction * 0.25, 0)
	rotation += deg_to_rad(6)
	
	if target != null:
		position = target.position
	
	if lifetime % 4 == 0:
		$".".play()
		fire()
	
	if lifetime == 0:
		queue_free()

func fire():
	var bullet = preload("res://Scenes/Player/Classes/deadeye/aimed_bullet.tscn").instantiate()
	
	var dir = Vector2.from_angle(rotation)
	
	bullet.set_player(player)
	bullet.set_damage(damage)
	bullet.set_knockback(5)
	bullet.set_pos(position + Vector2(80 * dir[0], 80 * dir[1]))
	bullet.set_stuntime(15)
	bullet.set_size(1.25)
	bullet.set_hitnum(100)
	bullet.set_speed(350 * dir[0], 350 * dir[1])
	bullet.set_lifetime(100)
	bullet.set_ult_charge_amount(15)

	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child", bullet)
