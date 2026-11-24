extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []
var damage_multi = 1

func _ready() -> void:
	set_status()
	self.scale.x = size
	self.scale.y = size
	
	hitnum = 0
	lifetime = 280

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()
	
	if lifetime > 210 and lifetime < 250:
		$AnimatedSprite2D.scale += Vector2(1, 1)
	
	if lifetime == 200:
		hitnum = 100
		$anim1.play()
		player.get_parent().set_screenshake(5)
	
	if lifetime == 190:
		$anim2.play()
		player.get_parent().set_screenshake(5)
	
	
	if lifetime == 180:
		already_hit = []
		$anim3.play()
		player.get_parent().set_screenshake(5)
	

	if lifetime == 170:
		already_hit = []
		$anim4.play()
		player.get_parent().set_screenshake(5)
	

	if lifetime == 160:
		already_hit = []
		$anim5.play()
		player.get_parent().set_screenshake(5)
	
	
	if lifetime == 120:
		$anim6.play()
		$anim7.play()
		player.get_parent().set_screenshake(90)
	
		
	if lifetime == 106:
		already_hit = []
		damage_multi = 5
		$"2".disabled = false
		$"1".disabled = true
		$CPUParticles2D.emitting = true
	
	if lifetime == 96:
		hitnum = 0
	
	if lifetime < 40:
		$AnimatedSprite2D.scale -= Vector2(1, 1)
		
	var collisions = self.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			charge_ult()
			collider.take_damage(damage * damage_multi, defense_pen, 0)
			collider.inflict_shock(100)
			collider.take_stun(stuntime)
			collider.take_knockback(knockback, direction)
			collider.take_knockbackY(knockbackY)
			collider.reset_gravity()
			hitnum -= 1
			already_hit += [collider]
	lifetime -= 1
