extends enemyBase
var stats_offset = Vector2(170, -60)

@onready var odon_sprite = $OdonSprite

@export var Boss_bar_name = "ODON"

var boss_bar_preload = preload("res://Scenes/Mobs/UI/boss_health_bar/boss_health_bar.tscn")
var hitnum = 0
var bonus_hit_speed = 0
var attack = 1
var attack2cd = 0

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
	description = "[b]Odon[/b]\nLevel: %d\n\n[i]\"Baby spin me round..\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA member of a hero party lost in the past. The juggernaut of the twins.\n\nDrops:\n50-60 xp\n\nBoss perk: stunned for 70%% less time." % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func move(animation):
	face_player(animation)
	if self.is_on_floor() and abs(self.position.x - player.position.x) > 200:
		animation.play("walk")
		self.position.x += Speed * direction
	else:
		animation.play("idle")

	set_direction(self, player)

func on_death():
	if death_rewards == 1:
		player.gain_xp(randi_range(50, 60))
	death_rewards = 0
	boss_bar.queue_free()
	queue_free()

func attack_1_attacking():
	var colliders = $attack_1_area.get_overlapping_bodies()
	
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable") and hitnum == 1:
			collider.take_damage(Damage, Defense_pen)
			collider.get_status_effect().inflict_bleed(3)
			collider.take_knockback(11, direction)
			collider.take_stun(45)
			hitnum = 0

func attack_2_attacking():
	var colliders = $attack_2_area.get_overlapping_bodies()
	for i in range(len(colliders)):
		var collider = colliders[i]
		if collider.is_in_group("player") and collider.is_in_group("attackable") and attack2cd == 0:
			if hitnum != 1:
				collider.take_damage(float(Damage) * 0.05, 100)
				collider.take_knockback(0.75, direction)
			else:
				collider.take_damage(float(Damage), Defense_pen)
				collider.take_knockback(10, direction)
			collider.take_stun(10)

func take_stun(stun_time):
	var reduced_stuntime = int(stun_time * 0.3)
	
	if shock_stacks == 0 or stunnedf == 0: 
		stunnedf = reduced_stuntime
	else:
		stunnedf += int(reduced_stuntime * (shock_stacks/100))

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 880 + (level * 120)
		Max_Health = 880 + (level * 120)
		Defense = 3
		Speed = 4
		Damage = 50 + (level * 5)
		Name = "Odon"
		phase = 0
		
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
	if attack2cd > 0:
		attack2cd -= 1
	if attackt >= 0 and attackt <= 149:
		if stunnedf == 0:
			move($OdonSprite)
			attackt += 1
		else:
			odon_sprite.play("idle")
			odon_sprite.pause()
			stunnedf -= 1
	if attackt == 149:
		if abs(self.position.x - player.position.x) > 400:
			attack = 2
		else:
			attack = 1

	if attack == 1:
		if attackt >= 150 and attackt <= 210:

			if attackt == 151:
				set_direction(self, player)
				face_player(odon_sprite)
				$OdonSprite.play("attack_1")
				$attack_1_area.position.x = direction * 196
			
			if attackt == 190:
				hitnum = 1
			
			if hitnum == 1:
				attack_1_attacking()
			attackt += 1
		if attackt >= 210:
			hitnum = 0
			attackt = 0

	if attack == 2:
		if attackt >= 150 and attackt <= 220:

			if attackt == 151:
				set_direction(self, player)
				face_player(odon_sprite)
				$OdonSprite.play("attack_2")
				self.velocity.x = 1400 * direction
				$attack_2_area.position.x = direction * 110
			
			if attackt == 165:
				hitnum = 10
			
			if attackt == 200:
				hitnum = 0
			
			if hitnum > 0:
				attack_2_attacking()
				if attack2cd == 0:
					hitnum -= 1
					attack2cd = 3
			attackt += 1
		if attackt >= 220:
			hitnum = 0
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
