extends enemyBase

var bone = preload("res://Scenes/Mobs/Skelebone/bone.tscn")
var attackt = 0

var skeleton_animation

func set_pos(pos):
	position = pos

func move(animation):
	skeleton_animation = animation

	animation.speed_scale = Speed * 0.1
	if self.is_on_floor():
		animation.play("walk")
	else:
		animation.play("idle")

	if animation.frame >= 3 and animation.frame <= 4:
		if self.is_on_floor(): # only move the skeleton x position if on ground
			self.position.x += 0.2 * Speed * direction
			face_player(animation)

	set_direction(self, player)

func throw_bone():
	var projectile = bone.instantiate()
	var proj_position = self.position + Vector2(self.direction * 6, -100)
	var proj_speed = 10 + abs(self.position.x - player.position.x) * 0.005
	var proj_lifetime = 90
	
	projectile.init(proj_position, proj_speed, self.direction, proj_lifetime)
	projectile.set_damage(Damage)
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func on_death():
	player.gain_xp(10)
	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 100 + (level * 30)
		Max_Health = 100 + (level * 30)
		
		Damage = 25 + (level * 2)
		
		update_hp_bar()

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func _physics_process(_delta: float) -> void:
	
	if attackt >= 0 and attackt <= 133:
		if stunnedf == 0:
			move($SkeleboneSprite)
			attackt += 1
		else:
			skeleton_animation.play("idle")
			skeleton_animation.pause()
			stunnedf -= 1
		
	elif attackt >= 134 and attackt <= 180:
		if attackt == 134:
			face_player(skeleton_animation)
			$SkeleboneSprite.play("attack")
		
		if attackt == 174:
			throw_bone()
	
		attackt += 1
	if attackt >= 180:
		attackt = 0
	
	take_all_status_effects()
	
	friction()
	vert_velocities()
	move_and_slide()
