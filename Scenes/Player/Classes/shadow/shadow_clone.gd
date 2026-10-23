extends CharacterBody2D

static var clone_list = []

var target
var valid_target
var direction = 1
var player
var speed = randf_range(Global.agility * 0.1, Global.agility * 0.2)

var lifetime = 1200
var max_lifetime = 1200

func set_dir(val):
	direction = val

func set_pos(val):
	position = val

func set_player(ply):
	player = ply

func spike():
	var shadow_spike = preload("res://Scenes/Player/Classes/shadow/shadow_spike.tscn").instantiate()
	shadow_spike.set_player(self)
	shadow_spike.set_direction(direction)
	shadow_spike.set_damage((0.15 * Global.power) + (0.15 * Global.dexterity))
	shadow_spike.set_knockback(2)
	shadow_spike.set_pos(position + Vector2(235 * direction, -60))
	shadow_spike.set_size(1.5)
	shadow_spike.set_stuntime(3)
	shadow_spike.set_rotate_level(1)
	shadow_spike.set_ult_charge_amount(5)
	shadow_spike.set_clone_spike()

	get_tree().current_scene.get_node("Projectiles").add_child(shadow_spike)

func _ready() -> void:
	$ProgressBar.max_value = max_lifetime
	clone_list += [self]
	while len(clone_list) > 4:
		clone_list[0].queue_free()
		clone_list.pop_front()

func _physics_process(_delta: float) -> void:
	var enemy_list = get_tree().current_scene.get_node("Enemies")
	if enemy_list.get_child_count() > 0:
		for i in range(enemy_list.get_child_count()):
			if i == 0:
				valid_target = enemy_list.get_child(0)
			target = enemy_list.get_child(i)
			if target.is_in_group("attackable") and target.is_in_group("enemy"):
				if abs(target.position.x - self.position.x) < abs(valid_target.position.x - self.position.x):
					valid_target = target
	
	if lifetime == max_lifetime:
		if direction == -1:
			$animation.flip_h = true
		else:
			$animation.flip_h = false
	
	if lifetime < max_lifetime-60:
		if valid_target != null:
			if abs(position.x - valid_target.position.x) < 200:
				attack()
			else:
				walk(valid_target)
		else:
			$animation.play("idle")

	lifetime -= 1
	$ProgressBar.value = lifetime

	if lifetime == 0:
		clone_list.erase(self)
		queue_free()

	velocity.y += Global.Gravity
	move_and_slide()

func attack():
	if $animation.animation == "idle":
		$animation.play("walk")
	if $animation.animation == "walk":
		if position.x > valid_target.position.x:
			direction = -1
			$animation.flip_h = true
		else:
			direction = 1
			$animation.flip_h = false
		$animation.play("attacking")

func walk(val):
	if $animation.animation == "idle":
		$animation.play("walk")
	if $animation.animation == "walk":
		if position.x > val.position.x:
			direction = -1
			$animation.flip_h = true
		else:
			direction = 1
			$animation.flip_h = false
		self.position.x += direction * speed

func _on_animation_animation_finished() -> void:
	if $animation.animation == "attacking":
		$animation.play("walk")


func _on_animation_frame_changed() -> void:
	if $animation.animation == "attacking" and $animation.frame == 2:
		spike()
