extends enemyBase

var thorn_preload = preload("res://Scenes/Bosses/Merchant/thorn.tscn")
var boss_bar_preload = preload("res://Scenes/Mobs/UI/boss_health_bar/boss_health_bar.tscn")

var stats_offset = Vector2(150, -60)
static var deaths = 0

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

func thorn():
	var shock_thorn = thorn_preload.instantiate()
	shock_thorn.set_pos(position + Vector2(220, -35))
	shock_thorn.set_damage(Damage)
	get_tree().current_scene.get_node("Projectiles").add_child(shock_thorn)

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
		phases = {0: [50, 0], 1: [0, 1]}
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
			thorn()

		if attackt >= 162 and attackt <= 166 and attackt % 2 == 0 and randi_range(0, 1) == 1:
			thorn()
	
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
