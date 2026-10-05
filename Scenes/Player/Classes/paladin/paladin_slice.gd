extends "res://Scenes/Player/Classes/projectile_base.gd"

func _ready() -> void:
	scale = Vector2(size, size)
	lifetime = 40
	fix_rotation()

func _physics_process(_delta: float) -> void:
	
	if lifetime == 0:
		queue_free()

	if lifetime < 15:
		position.y += 10
		scale *= Vector2(0.98, 0.98)
		position += speed * Vector2(pow(0.97, 15-lifetime), 0)
	else:
		position += speed

	if lifetime > 10 and lifetime % 4 == 0:
		var collisions = self.get_overlapping_bodies()
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy"):
				charge_ult()
				if lifetime == 40:
					collider.take_damage(damage * 10, defense_pen, 0)
				else:
					collider.take_damage(damage, defense_pen, 0)
				collider.take_stun(stuntime)
				collider.take_knockback(knockback, direction)
				collider.take_knockbackY(knockbackY)
				collider.reset_gravity()
	lifetime -= 1
