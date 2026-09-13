extends "res://Scenes/Player/Classes/projectile_base.gd"
var fire_stacks = 0
var already_hit = []

func set_fire(value):
	fire_stacks = value

func _on_body_entered(body: Node2D) -> void:
	
	var collider = body
	if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
		charge_ult()
		collider.take_damage(damage, calc_pierce(collider.get_defense()))
		collider.take_knockback(knockback, direction)
		collider.take_knockbackY(knockbackY)
		collider.reset_gravity()
		collider.take_stun(stuntime)
		already_hit += [collider]
		if fire_stacks > 0:
			collider.inflict_fire(fire_stacks)
		hitnum -= 1
