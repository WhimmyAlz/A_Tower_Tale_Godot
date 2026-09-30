extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []

var explosion_preload = preload("res://Scenes/Player/Classes/reaper/explosion.tscn")

func spawn_explosion(collider):
	var explosion = explosion_preload.instantiate()
	explosion.set_damage(damage * 0.5)
	explosion.set_knockback(5)
	collider.reset_gravity()
	explosion.set_pos(collider.position + Vector2(randi_range(-100,100),randi_range(-250,250)))
	explosion.set_speed(0, 0)
	explosion.set_lifetime(50)
	explosion.set_stuntime(30)
	explosion.set_ult_charge_amount(0)
	explosion.set_size(randi_range(2,6))
	explosion.set_hitnum(100)
	explosion.set_early_explosion(randi_range(1,3))
	get_tree().current_scene.get_node("Projectiles").call_deferred("add_child",explosion)


func _physics_process(_delta: float) -> void:
	self.position += speed
	fix_rotation()
	lifetime -= 1
	
	if lifetime < 10:
		hitnum = 0
	else:
		scale *= Vector2(1.01,1.01)
	
	if lifetime == 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	
	var collider = body
	if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
		charge_ult()
		collider.take_damage(damage, calc_pierce(collider.get_defense()))
		collider.take_knockback(knockback, direction)
		collider.take_knockbackY(knockbackY)
		collider.reset_gravity()
		collider.take_stun(stuntime)
		for i in range(4):
			spawn_explosion(collider)
		already_hit += [collider]
		hitnum -= 1
