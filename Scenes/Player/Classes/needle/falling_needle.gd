extends "res://Scenes/Player/Classes/projectile_base.gd"

var already_hit = []
var target

func set_target(val):
	target = val

func _ready() -> void:
	lifetime = 90
	set_status()
	scale.y = size
	scale.x = size

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()
	if lifetime == 90:
		if angle == 0:
			speed = Vector2(0, 90)
		elif angle == 60:
			speed = Vector2(-120, 60)
		elif angle == -60:
			speed = Vector2(120, 60)

	var collisions = self.get_overlapping_bodies()

	if lifetime >= 40 and target != null:
		position = target.position + speed * Vector2(-5, -6)

	if lifetime < 40:
		position += speed
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
				collider.take_damage(damage, defense_pen, 0)
				collider.take_stun(stuntime)
				collider.take_knockback(0, 0)
				collider.reset_gravity()
				hitnum -= 1
				already_hit += [collider]
	lifetime -= 1
