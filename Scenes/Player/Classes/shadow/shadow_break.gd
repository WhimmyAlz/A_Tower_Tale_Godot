extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

func _ready() -> void:
	lifetime = 18
	set_status()
	scale = Vector2(size, size)
	fix_rotation()

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()

	if lifetime == 18:
		var amount = randi_range(-5, 5) * direction
		set_rotate(amount)
		self.position.y += amount

	if lifetime == 15:
		$AnimatedSprite2D.play()
	
	if lifetime < 10:
		var collisions = self.get_overlapping_bodies()
		
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
				charge_ult()
				collider.take_damage(damage, defense_pen)
				collider.take_stun(stuntime)
				collider.inflict_shock(50)
				collider.take_knockback(knockback, direction)
				collider.reset_gravity()
				hitnum -= 1
				already_hit += [collider]
	lifetime -= 1
