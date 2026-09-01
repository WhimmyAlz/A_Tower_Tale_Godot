extends "res://Scenes/Player/Classes/projectile_base.gd"

var already_hit = []

func _ready() -> void:
	hitnum = 100
	lifetime = 22
	knockback = 30
	stuntime = 180
	self.scale.x = size
	self.scale.y = size
	fix_rotation()

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()
	
	var collisions = self.get_overlapping_bodies()
	var kb_dir = -1
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			collider.take_damage(damage, defense_pen, 0)
			if collider.position.x > position.x:
				kb_dir = 1
			collider.take_stun(stuntime)
			collider.take_knockback(knockback, kb_dir)
			already_hit += [collider]
			hitnum -= 1
