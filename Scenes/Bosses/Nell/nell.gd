extends enemyBase

var arrow = preload("res://Scenes/Bosses/Nell/fire_arrow.tscn")

var stats_offset = Vector2(170, -70)
var shots = 0
var dodge_cd = 0
@onready var nell_animation = $NellSprite

@export var Boss_bar_name = "NELL"

var boss_bar_preload = preload("res://Scenes/Mobs/UI/boss_health_bar/boss_health_bar.tscn")

func init_boss_bar():
	boss_bar = boss_bar_preload.instantiate()
	boss_bar.visible = false
	boss_bar.update_name("[b]%s[/b]" % Boss_bar_name)
	get_tree().current_scene.get_node("Boss_Health_Bars").get_node("boss_hp_container").add_child(boss_bar)

func update_hp_bar():
	$HealthBar.update_value(Health)
	$HealthBar.update_max_value(Max_Health)
	boss_bar.update_value(Health)
	boss_bar.update_max_value(Max_Health)

func set_description():
	description = "[b]Nell[/b]\nLevel: %d\n\n[i]\"My arrows will do something.\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA member of a hero party lost in the past. The ranger of the twins.\n\nDrops:\n10-16 xp" % [Level, Health, Damage, Defense, Defense_pen]

func check_phase():
	if phases[phase][1] > 0:

		if phases[phase][1] == 1:
			# check if enemy is "passive" before damaged
			if phase == 1:
				var enemy_list = get_tree().current_scene.get_node("Enemies")
				attackt = attackt_start
				for i in range(enemy_list.get_child_count()):
					if enemy_list.get_child(i).Name == "Odon":
						enemy_list.get_child(i).take_damage(fire_stacks / 2, 10, 0, Color.WHITE)
				if boss_bar != null:
					boss_bar.visible = true

		phases[phase][1] -= 1

func set_pos(pos):
	position = pos

func move(animation):
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) < 1200:
		if abs(self.position.x - player.position.x) < 200 and dodge_cd == 0:
			dodge()
			dodge_cd = 600
		elif abs(self.position.x - player.position.x) < 1200:
			animation.play("walk")
			self.position.x -= Speed * direction
	else:
		animation.play("idle")
	set_direction(self, player)

func dodge():
	var enemy_list = get_tree().current_scene.get_node("Enemies")
	var closest_enemy = null
	if enemy_list.get_child_count() > 0:
		closest_enemy = enemy_list.get_child(0)
		for i in range(enemy_list.get_child_count()):
			if enemy_list.get_child(i) != self and abs(enemy_list.get_child(i).position.x - position.x) < abs(closest_enemy.position.x - position.x):
				closest_enemy = enemy_list.get_child(i)
				
			# prefers dodging using odon
			if enemy_list.get_child(i).Name == "Odon":
				closest_enemy = enemy_list.get_child(i)
				break
		closest_enemy.velocity.x = 2 * (player.position.x - closest_enemy.position.x)
		velocity.x = direction * 2500
		attackt = 200

func shoot():
	var projectile = arrow.instantiate()
	projectile.set_pos(position + Vector2(direction * 60, -35))
	projectile.set_damage(Damage)
	projectile.set_direction(direction)
	projectile.set_defense_pen(Defense_pen)
	projectile.get_shooter(self)
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(10, 16))
		check_class_misc()
	death_rewards = 0
	boss_bar.queue_free()
	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 900 + (level * 90)
		Max_Health = 900 + (level * 90)
		Defense = 2
		Speed = 4
		Damage = 10 + (level * 1)
		Defense_pen = 5

	Name = "Nell"
	phase = 0
	Boss = true
	init_boss_bar()
	update_hp_bar()
	
	set_description()

	update_display_name(Name)
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(3)
	$EnemyStatsList.set_text(description)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func _physics_process(_delta: float) -> void:
	if dodge_cd > 0:
		dodge_cd -= 1
	if attackt >= 0 and attackt <= 199:
		if attackt == 0:
			shots = 0
		if stunnedf == 0:
			move($NellSprite)
			attackt += 1
		else:
			nell_animation.play("idle")
			nell_animation.pause()
			stunnedf -= 1
		
	elif attackt >= 200 and attackt <= 265:
		if attackt == 201:
			set_direction(self, player)
			face_player(nell_animation)
			$NellSprite.play("attack")
		
		if attackt == 220:
			shots += 1
			shoot()
		attackt += 1
	if attackt >= 265:
		if stunnedf == 0 and shots < 3:
			$NellSprite.frame = 0
			attackt = 199
		else:
			attackt = 0
		
	take_all_status_effects()
	
	check_phase()
	spawn_frames()
	friction()
	vert_velocities()
	move_and_slide()
	
	if mouse_over:
		update_description()

func update_description():
	set_description()
	$EnemyStatsList.set_text(description)
	$EnemyStatsList.fix_pos()

func _on_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true

func _on_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false
