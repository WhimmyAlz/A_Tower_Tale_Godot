extends "res://Scenes/Player/Classes/projectile_base.gd"

var target
var collided = false
func _ready() -> void:
	set_status()
	scale.y = size
	scale.x = size
	look_at(target.position)
	speed = (target.position - position) * 0.05
	target.take_stun((lifetime-40) * 5)

func set_target(val):
	target = val

func _physics_process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime == 0:
		queue_free()

	var collisions = self.get_overlapping_bodies()
	
	if lifetime == 40 and target != null:
		speed = (target.position - position) * 0.05
		look_at(target.position)

	if lifetime < 10:
		scale *= 0.9
	
	if lifetime < 40:
		if not collided:
			position += speed
		for collider in collisions:
			if collider.is_in_group("attackable") and collider.is_in_group("enemy") and collider == target and hitnum >= 1:
				collider.take_damage(damage, defense_pen, 0)
				collider.take_stun(stuntime)
				collider.take_knockback(0, 0)
				collider.reset_gravity()
				hitnum -= 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("ground"):
		collided = true
		player.get_parent().set_screenshake(10)
