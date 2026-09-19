extends enemyBase

var thorn_preload = preload("res://Scenes/Bosses/Merchant/thorn.tscn")
var boss_bar_preload = preload("res://Scenes/Mobs/UI/boss_health_bar/boss_health_bar.tscn")

var stats_offset = Vector2(150, -60)
static var deaths = 0

var entered

@onready var animation = $MerchantSprite

@export var Boss_bar_name = "EL TRUT"
func init_boss_bar():
	boss_bar = boss_bar_preload.instantiate()
	boss_bar.visible = false
	boss_bar.update_name("[b]%s[/b]" % Boss_bar_name)
	get_tree().current_scene.get_node("Boss_Health_Bars").get_node("boss_hp_container").add_child(boss_bar)

func update_hp_bar():
	$HealthBar.update_value(Health)
	$HealthBar.update_max_value(Max_Health)
	boss_bar.update_value(Health)
	boss_bar.update_max_value(Max_Health/2)

func set_description():
	description = "[b]A shell or something[/b]\nLevel: %d\n\n[i]\"Don't think I can't defend my merchandise.\"[/i]\n\nHealth: %d\nDamage: %d\nDefense: %d\nDefense Penetration: %d\n\nDescription:\nA strange voice is coming from within.\n\nDrops:\n100%% 50-100 xp\n\nBoss perks: Immune to knockback and 50%% resistance to bleeding and mark of doom." % [Level, Health, Damage, Defense, Defense_pen]

func set_pos(pos):
	position = pos

func take_knockback(_kb, _dir):
	pass

func take_knockbackY(_kb):
	pass

func take_bleed():
	if bleed_stacks >= 1 and bleed_tick_delay == 0:
		bleed_stacks -= 1
		bleed_tick_delay = 30
		take_damage(float(Max_Health/200), 1000, 0, Color.DARK_RED)
	elif bleed_tick_delay > 0:
		bleed_tick_delay -= 1

func take_deathmark():
	if deathmark_stacks == 1000:
		take_damage(float(Max_Health/10), 1000, 0, Color.BLACK)
		deathmark_stacks = 0
	elif deathmark_stacks >= 1 and deathmark_tick_delay == 0:
		deathmark_stacks = 0
	elif deathmark_tick_delay > 0:
		deathmark_tick_delay -= 1

func move(_anim):
	# move (he doesn't move)
	animation.play("idle")

func thorn(spd):
	var shock_thorn = thorn_preload.instantiate()
	shock_thorn.set_pos(position + Vector2(220, -35))
	shock_thorn.set_damage(Damage)
	shock_thorn.set_speed_multi(spd)
	get_tree().current_scene.get_node("Projectiles").add_child(shock_thorn)

func check_phase():
	if phases[phase][1] > 0:
		
		if phase == 2:
			if Health <= 0:
				Health = 1.0

			attackt = 0
			Health += (Max_Health * 0.0025)
			update_hp_bar()
			remove_from_group("attackable")
		
		if phases[phase][1] == 1:
			# check if enemy is "passive" before damaged
			if phase == 1:
				attackt = attackt_start
				if boss_bar != null:
					boss_bar.visible = true
			if phase == 2:
				add_to_group("attackable")

		phases[phase][1] -= 1


func on_death():
	boss_bar.queue_free()
	player.gain_xp(randi_range(50, 100))

	queue_free()

func set_level_stats():
	# Reminder to self:
	# Level is display level while level is used functionally
	var level = Level - 1
	
	if check_stats_unchanged():
		Health = 1000 + (level * 10)
		Max_Health = 1000 + (level * 10)
		Damage = 10 + (level * 0.1)
		Defense = 20 + (level * 0.2)
		Defense_pen = 10
		Weight = 360
		Speed = 0
		phase = 0
		attackt_start = 110
		phases = {0: [50, 0], 1: [1, 1], 2 : [0, 200]}
		Name = "???"
	
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
	if phase == 0 and entered and Input.is_action_just_pressed("interact"):
		if $Shop.visible:
			$Shop.visible = false
		else:
			$Shop.visible = true
			
	if phase == 1:
		if attackt >= 0 and attackt <= 119:
			if stunnedf == 0:
				move(animation)
				attackt += 1
			else:
				animation.play("idle")
				animation.pause()
				stunnedf -= 1
			
		elif attackt >= 120 and attackt <= 170:
			if attackt == 120:
				animation.play("attack")
			
			if attackt == 160:
				thorn(1)

			if attackt >= 162 and attackt <= 166 and attackt % 2 == 0 and randi_range(0, 1) == 1:
				thorn(1)
		
			attackt += 1
		if attackt >= 170:
			attackt = 0
	elif phase == 2:
		if attackt >= 0 and attackt <= 119:
			if stunnedf == 0:
				move(animation)
				attackt += 1
			else:
				animation.play("idle")
				animation.pause()
				stunnedf -= 1
			
		elif attackt >= 120 and attackt <= 170:
			if attackt == 120:
				animation.play("attack")
			
			if attackt == 160:
				thorn(3)

			if attackt >= 160 and attackt <= 169 and attackt % 2 == 0 and randi_range(0, 1) == 1:
				thorn(20)
		
			attackt += 1
		if attackt >= 170:
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

func _on_shop_colision_body_entered(body: Node2D) -> void:
	var collider = body
	if collider.is_in_group("player"):
		entered = true
		print("true")

func _on_shop_colision_body_exited(body: Node2D) -> void:
	var collider = body
	if collider.is_in_group("player"):
		entered = false
