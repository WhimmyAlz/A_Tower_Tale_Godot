extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

var target

func set_target(val):
	target = val

func _ready() -> void:
	set_status()
	fix_rotation()
	scale = Vector2(size, size)


func fix_rotation():
	self.rotation = angle
	if direction == -1:
		$Control/AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$Control/AnimatedSprite2D.flip_h = false

func change_scale(val):
	if direction == -1:
		$Control.size.x = (257 * val)+ 1
		$Control.position.x = (258 - $Control.size.x) - 129
		$CollisionShape2D.shape.size.x = (257 * val) + 1
		$CollisionShape2D.position.x = 128.5 - (128.5 * val)
	elif direction == 1:
		$Control.size.x = (257 * val)+ 1
		$CollisionShape2D.shape.size.x = (257 * val) + 1
		$CollisionShape2D.position.x = (128.5 * val) - 128.5

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()
	
	var collisions = self.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			charge_ult()
			collider.take_damage(damage, defense_pen, 0)
			collider.inflict_shock(10)
			collider.take_stun(stuntime)
			collider.take_knockback(knockback, direction)
			collider.take_knockbackY(knockbackY)
			collider.reset_gravity()
			hitnum -= 1
			already_hit += [collider]
	lifetime -= 1
