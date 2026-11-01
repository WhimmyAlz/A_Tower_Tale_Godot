extends enemyBase
var stats_offset = Vector2(170, -180)

@onready var MourningGhoulSprite = $MourningGhoulSprite

@export var Boss_bar_name = "MOURNING GHOUL"

var boss_bar_preload = preload("res://Scenes/Mobs/UI/boss_health_bar/boss_health_bar.tscn")

var attack := 0
var summon_cd := 0
var attack_combo := 0
var hitnum = 0

func check_phase():
	if phases[phase][1] > 0:

		if phases[phase][1] == 1:
			# check if enemy is "passive" before damaged
			if phase == 1:
				attackt = attackt_start
				if boss_bar != null:
					boss_bar.visible = true

		phases[phase][1] -= 1

func face_player(animation):
	if direction == -1:
		animation.flip_h = false
		$MourningGhoulSprite.position.x = 230
	elif direction == 1:
		animation.flip_h = true
		$MourningGhoulSprite.position.x = -171


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
	description = "[b]Mourning Ghoul[/b]\nLevel: %d\n\n[i]\"I must kill the hero...\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nAn ancient adventurer who succumbed to the decay. A mother of a pair of twins who perished before herself.\n\nDrops:\n20-24 Essence of Regret (100%%)\n5-8 Shadow Essence (100%%)\n35-48 Bone Fragment (100%%)\n%d-%d xp\n\nBoss perk: stunned for 50%% less time and significantly reduced knockback." % [Level, Health, Damage, Defense, Defense_pen, xp_range[0], xp_range[1]]

func set_pos(pos):
	position = pos

func summon_shadows(val=Level-6, enemy=null):
	var shadow_ball = preload("res://Scenes/Bosses/Mourning Ghoul/shadow_ball.tscn").instantiate()
	var scale_amount = randi_range(1, 10)
	shadow_ball.position = Vector2(randi_range(-900, 900), -700 * (1 + 0.1*scale_amount))
	shadow_ball.set_level(val)
	shadow_ball.set_scales(scale_amount*0.05 + 1)
	if enemy != null:
		shadow_ball.set_enemy(enemy)
	get_tree().current_scene.get_node("Projectiles").add_child(shadow_ball)

func attack1():
	var colliders = $attack1_collider.get_overlapping_bodies()
	
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable") and hitnum > 0:
			collider.take_damage(Damage, Defense_pen)
			collider.take_knockback(11, direction)
			collider.take_stun(45)
			hitnum -= 1

func move(animation):
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) > 350:
		animation.play("walk")
		if MourningGhoulSprite.frame > 3:
			self.position.x += Speed * direction
	else:
		animation.play("idle")

	set_direction(self, player)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(xp_range[0], xp_range[1]))
		check_class_misc()
		player.add_item("Bone Fragment", randi_range(35, 48))
		player.add_item("Shadow Essence", randi_range(5, 8), Color.RED)
		player.add_item("Essence of Regret", randi_range(20, 24), Color.RED)
	death_rewards = 0
	boss_bar.queue_free()
	queue_free()

func take_stun(stun_time):
	var reduced_stuntime = int(stun_time * 0.5)
	
	if shock_stacks == 0 or stunnedf == 0: 
		stunnedf = reduced_stuntime
	else:
		stunnedf += int(reduced_stuntime * (shock_stacks/100))

func take_knockback(kb, dir):
	self.velocity.x += kb * dir * 50 # 100 cuz kb too weak otherwise (want to use lower values)

func take_knockbackY(_kb):
	pass

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		xp_range = [150, 180]
		Health = 4000 + (level * 400)
		Max_Health = 4000 + (level * 400)
		Defense = 3
		Speed = 3
		Damage = 50 + (level * 5)
	phases = {0: [100, 0], 1: [50, 1], 2 : [0, 1]}
	Name = "Mourning Ghoul"
	phase = 0
	Boss = true
	init_boss_bar()
	update_hp_bar()
	
	set_description()

	update_display_name(Name)
	$EnemyStatsList.set_offset(stats_offset)
	$EnemyStatsList.set_size(3)
	$EnemyStatsList.set_text(description)
	$HealthBar.set_name_size(20)

## dto is damage text offset
func set_dto():
	damage_text_offset = Vector2(-40, -300)

func _physics_process(_delta: float) -> void:
	if summon_cd > 0:
		summon_cd -= 1
	if attackt >= 0 and attackt <= 149:
		if stunnedf == 0:
			move($MourningGhoulSprite)
			attackt += 1
		else:
			MourningGhoulSprite.play("idle")
			MourningGhoulSprite.pause()
			stunnedf -= 1
	if attackt == 150:
		if phase == 1:
			var enemy_amount = get_tree().current_scene.get_node("Enemies").get_child_count()
			if summon_cd == 0 and enemy_amount < 5:
				attack = 0
			else:
				attack = 1
		elif phase == 2:
			if summon_cd == 0:
				attack = 0
			else:
				attack = 1

	if phase == 1:
		if attack == 0:
			if attackt >= 150 and attackt <= 211:
				attackt += 1
				if attackt == 151:
					$MourningGhoulSprite.play("scream")
				if attackt == 201:
					for i in range(randi_range(3, 5)):
						summon_shadows()
					player.get_parent().set_screenshake(20)
				if attackt >= 211:
					attackt = 0
					summon_cd = 900
		if attack == 1:
			if attackt >= 150 and attackt <= 211:
				attackt += 1
				if attackt == 151:
					set_direction(self, player)
					face_player(MourningGhoulSprite)
					$attack1_collider.position.x = direction * 275
					$MourningGhoulSprite.play("swipe")
				if attackt == 181:
					hitnum = 1
					summon_shadows(Level-1, "hand")
				
				if attackt >= 181 and attackt <= 196:
					attack1()
				
				if attackt >= 211:
					if abs(self.position.x - player.position.x) < 350:
						attackt = 100
					else:
						attackt = 0
	elif phase == 2:
		if attack == 0:
			if attackt >= 150 and attackt <= 211:
				attackt += 1
				if attackt == 151:
					$MourningGhoulSprite.play("scream")
				if attackt == 201:
					player.get_parent().set_screenshake(20)
					player.take_stun(60)
				if attackt >= 211:
					attackt = 0
					attack_combo = 0
					summon_cd = 240
		if attack == 1:
			if attackt >= 150 and attackt <= 250:
				attackt += 1
				if attackt == 151:
					set_direction(self, player)
					face_player(MourningGhoulSprite)
					$attack1_collider.position.x = direction * 275
					$MourningGhoulSprite.play("swipe")

				if attackt == 181:
					hitnum = 1
					summon_shadows(Level-1, "hand")
				
				if attackt >= 181 and attackt <= 196:
					attack1()

				if attackt >= 211:
					if attack_combo < 3:
						attack_combo += 1
						attackt = 150
						$MourningGhoulSprite.play("idle")
					else:
						attackt = 0
						attack_combo = 0
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

func _on_stats_collider_mouse_entered() -> void:
	$EnemyStatsList.visible = true
	mouse_over = true
	update_description()

func _on_stats_collider_mouse_exited() -> void:
	mouse_over = false
	$EnemyStatsList.visible = false
