extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

var rotate_level

func set_rotate_level(val):
	rotate_level = val

func _ready() -> void:
	lifetime = 12
	set_status()
	scale = Vector2(size, size)
	fix_rotation()

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()
	
	if lifetime == 12:
		var amount = 0
		
		if rotate_level == 1:
			amount = randi_range(-25, 25) * direction
		set_rotate(amount)
		self.position.y += amount

	var collisions = self.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			charge_ult()
			collider.take_damage(damage, defense_pen)
			collider.take_stun(stuntime)
			collider.take_knockback(knockback, direction)
			collider.reset_gravity()
			hitnum -= 1
			already_hit += [collider]
	lifetime -= 1
