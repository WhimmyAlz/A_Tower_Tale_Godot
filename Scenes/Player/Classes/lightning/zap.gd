extends "res://Scenes/Player/Classes/projectile_base.gd"
var already_hit = []
var dmg_multi = 1.5

var saved_frame

func _ready() -> void:
	set_status()
	self.scale.x = size
	self.scale.y = size
	fix_rotation()
	
	$"1".position.x *= direction
	$"2".position.x *= direction
	$"3".position.x *= direction

func _physics_process(_delta: float) -> void:
	if lifetime == 0:
		queue_free()
	
	var collisions = self.get_overlapping_bodies()
	
	for collider in collisions:
		if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider not in already_hit and hitnum >= 1:
			charge_ult()
			collider.take_damage(damage * dmg_multi, defense_pen)
			collider.inflict_shock(5)
			collider.take_stun(stuntime)
			collider.take_knockback(knockback, direction)
			collider.take_knockbackY(knockbackY)
			collider.reset_gravity()
			hitnum -= 1
			already_hit += [collider]
			if  $AnimatedSprite2D.frame <= 2:
				saved_frame = $AnimatedSprite2D.frame
				$AnimatedSprite2D.play("expire")
				$AnimatedSprite2D.frame = saved_frame
				$AnimatedSprite2D.pause()
				if lifetime > 5:
					lifetime = 5
	lifetime -= 1


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 1:
		$"2".disabled = false
		dmg_multi = 1.35
	elif $AnimatedSprite2D.frame == 2:
		$"3".disabled = false
		dmg_multi = 1.15
	elif $AnimatedSprite2D.frame == 3:
		$"4".disabled = false
		dmg_multi = 1
