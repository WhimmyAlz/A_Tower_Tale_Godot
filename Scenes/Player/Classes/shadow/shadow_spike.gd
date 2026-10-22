extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

var rotate_level = 1
var clone_spike = false
var giant_spike = false

func set_giant_spike():
	giant_spike = true

func set_clone_spike():
	clone_spike = true

func set_rotate_level(val):
	rotate_level = val

func _ready() -> void:
	$AnimatedSprite2D.play()
	if giant_spike:
		$AnimatedSprite2D.play("giant")
	$AnimatedSprite2D.frame = 0
	lifetime = 12
	set_status()
	scale = Vector2(size, size)
	set_rot()
	if rotate_level != 3:
		fix_rotation()

func set_rot():
	var amount = 0
		
	if rotate_level == 1:
		amount = randi_range(-25, 25) * direction
		self.position.y += amount
		set_rotate(amount)
	elif rotate_level == 2:
		amount = randi_range(-5, 5) * direction
		self.position.y += amount
		set_rotate(amount)
	elif rotate_level == 3:
		amount = 270
		set_rotate(amount)

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()
	
	var collisions = self.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			charge_ult()
			if clone_spike:
				collider.take_damage(damage, defense_pen, 0)
			else:
				collider.take_damage(damage, defense_pen)
			collider.take_stun(stuntime)
			collider.take_knockback(knockback, direction)
			collider.take_knockbackY(knockbackY)
			collider.reset_gravity()
			hitnum -= 1
			already_hit += [collider]
	lifetime -= 1
