extends "res://Scenes/Player/Classes/projectile_base.gd"

var already_hit = []

var early_explosion = 0

func set_early_explosion(val):
	early_explosion = val

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()

	if lifetime > 20:
		speed *= Vector2(0.92, 1)
		self.position += speed
		if early_explosion > 0:
			lifetime = maxi(lifetime - early_explosion, 20)
	if early_explosion > 0 and lifetime == 20:
		$AnimatedSprite2D.frame = 9

	if lifetime >= 15 and lifetime <= 20:
		var collisions = self.get_overlapping_bodies()
		var kb_dir = -1
		
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
				if not status.get_river():
					charge_ult()
				collider.take_damage(damage, defense_pen, 0)
				if collider.position.x > position.x:
					kb_dir = 1
				if stuntime > 0:
					collider.take_stun(stuntime)
				collider.take_knockback(knockback, kb_dir)
				collider.take_knockbackY(knockbackY)
				if stuntime == 0:
					collider.reset_gravity()
				already_hit += [collider]
				hitnum -= 1
