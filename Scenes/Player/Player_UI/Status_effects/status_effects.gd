extends Node2D

@onready var player = get_parent().get_parent().get_body()

var preload_river_bg = preload("res://Scenes/Player/Classes/reaper/river_bg.tscn")
var river_bg

var borrowed_time_circle

var preload_status_box = preload("res://Scenes/Player/Player_UI/Status_effects/status_effect_box.tscn")
var status_box

var berserk = false
var berserk_time := 0

var river = false
var river_time := 0

var defensive_stance = 0
var defensive_stance_time := 0

var needle_stacks = 0
var needle_tick_delay := 0

var retribution_stacks = 0
var retribution_tick_delay := 0

var borrowed_time = false
var borrowed_time_tick_delay := 0
var bt_previous_health 

var fire_stacks = 0.0
var fire_tick_delay := 0

var venom_stacks = 0.0
var venom_tick_delay := 0

var shock_stacks = 0.0
var shock_tick_delay = 0

var bleed_stacks = 0.0
var bleed_tick_delay = 0

var deathmark_stacks = 0.0
var deathmark_tick_delay = 0

func init_status_box(status, status_level, time, color, font=48):
	status_box = preload_status_box.instantiate()
	status_box.set_status(status)
	status_box.set_status_level(status_level)
	status_box.set_time(time)
	status_box.set_color(color)
	status_box.set_text_size(font)
	$FlowContainer.call_deferred("add_child", status_box)

func set_status_font_size(status, size):
	for i in range(self.get_child(0).get_child_count()):
		var effect = self.get_child(0).get_child(i-1)
		if effect.get_status() == status:
			effect.set_text_size(size)

func check_dupes(status):
	for i in range(self.get_child(0).get_child_count()):
		var effect = self.get_child(0).get_child(i-1)
		if effect.get_status() == status:
			return(true)
	return(false)


func update_status_box(status, status_level, time):
	for i in range(self.get_child(0).get_child_count()):
		var effect = self.get_child(0).get_child(i-1)
		if effect.get_status() == status:
			effect.set_status_level(status_level)
			effect.set_time(time)

func get_berserk():
	return(berserk)

func get_river():
	return(river)

func get_shock():
	return(shock_stacks)

func get_needles():
	return(needle_stacks)

func remove_needles(stacks):
	needle_stacks -= stacks
	if needle_stacks <= 0:
		needle_tick_delay = 1
	update_status_box("Needle Stacks", needle_stacks, needle_tick_delay)

func get_retribution():
	return(retribution_stacks)

func get_borrowed_time():
	return(borrowed_time)

func remove_retribution(stacks):
	retribution_stacks -= stacks
	if retribution_stacks <= 0:
		retribution_tick_delay = 1
	update_status_box("Retribution", retribution_stacks, retribution_tick_delay)


func set_berserk(time):
	if berserk == false:
		init_status_box("Berserk", 1, time, Color.RED)
		Global.bonus_strength += 10
		Global.bonus_agility += 15
		Global.stamina_regen_multi += 1
	else:
		update_status_box("Berserk", 1, time)
	berserk = true
	berserk_time = time

func start_river(time):
	if river == false:
		init_status_box("River", 1, time, Color.DARK_SLATE_BLUE)
		river_bg = preload_river_bg.instantiate()
		get_tree().current_scene.get_node("Enviroment").get_node("Walls_and_sprites").get_node("Sprites").add_child(river_bg)
	else:
		update_status_box("River", 1, time)
	river = true
	if river_time < time:
		river_time = time

func set_defensive_stance(level, time):
	defensive_stance_time = time
	if defensive_stance == 0:
		init_status_box("Defensive Stance", defensive_stance, defensive_stance_time, Color.DIM_GRAY)
		Global.bonus_defense += level * 10
	else:
		Global.bonus_defense += (level - defensive_stance) * 10
		update_status_box("Defensive Stance", defensive_stance, defensive_stance_time)
	defensive_stance = level

func add_river(time):
	if river == true:
		river_time += time
		update_status_box("River", 1, river_time)

func add_needles(stacks):
	needle_tick_delay = 6000
	if needle_stacks <= 10:
		if needle_stacks > 0:
			needle_stacks = mini(needle_stacks + stacks, 10)
			update_status_box("Needle Stacks", needle_stacks, needle_tick_delay)
		else:
			needle_stacks = mini(needle_stacks + stacks, 10)
			init_status_box("Needle Stacks", needle_stacks, needle_tick_delay, Color.WHITE)
		set_status_font_size("Needle Stacks", 45)

func set_borrowed_time(time):
	if borrowed_time == false:
		init_status_box("Borrowed Time", 1, time, Color.SKY_BLUE)
		borrowed_time_circle = preload("res://Scenes/Player/Classes/paladin/borrowed_time.tscn").instantiate()
		get_tree().current_scene.get_node("Projectiles").add_child(borrowed_time_circle)
	else:
		update_status_box("Borrowed Time", 1, time)
	borrowed_time_circle.set_max_healable(Global.health)
	borrowed_time_circle.set_lifetime(time)
	borrowed_time = true
	borrowed_time_tick_delay = time

func add_retribution(stacks):
	retribution_tick_delay = 6000
	if retribution_stacks <= 200:
		if retribution_stacks > 0:
			retribution_stacks = mini(retribution_stacks + stacks, 200)
			update_status_box("Retribution", retribution_stacks, retribution_tick_delay)
		else:
			retribution_stacks = mini(needle_stacks + stacks, 200)
			init_status_box("Retribution", retribution_stacks, retribution_tick_delay, Color.SKY_BLUE, 40)
		set_status_font_size("Retribution", 40)


func inflict_fire(stacks):
	if fire_stacks <= 50:
		if fire_stacks > 0:
			fire_stacks = mini(fire_stacks + stacks, 50)
			update_status_box("Fire", fire_stacks, 15 * fire_stacks)
		else:
			fire_stacks = mini(fire_stacks + stacks, 50)
			init_status_box("Fire", fire_stacks, 15 * fire_stacks, Color.ORANGE_RED)

func inflict_venom(stacks):
	if venom_stacks <= 30:
		if venom_stacks > 0:
			venom_stacks = mini(venom_stacks + stacks, 30)
			update_status_box("Venom", venom_stacks, 20 * venom_stacks)
		else:
			venom_stacks = mini(venom_stacks + stacks, 30)
			init_status_box("Venom", venom_stacks, 20 * venom_stacks, Color.PURPLE)

func inflict_shock(stacks):
	if shock_stacks <= 100:
		if shock_stacks > 0:
			shock_stacks = mini(shock_stacks + stacks, 100)
			update_status_box("Shock", shock_stacks, shock_time_calc())
		else:
			shock_stacks = mini(shock_stacks + stacks, 100)
			init_status_box("Shock", shock_stacks, shock_time_calc(), Color.YELLOW)

func inflict_bleed(stacks):
	if bleed_stacks <= 10:
		if bleed_stacks > 0:
			bleed_stacks = mini(bleed_stacks + stacks, 10)
			update_status_box("Bleeding", 1, 30 * bleed_stacks)
		else:
			bleed_stacks = mini(bleed_stacks + stacks, 10)
			init_status_box("Bleeding", 1, 30 * bleed_stacks, Color.DARK_RED)

func inflict_deathmark(stacks):
	if deathmark_stacks <= 1000:
		deathmark_tick_delay = 300
		if deathmark_stacks > 0:
			deathmark_stacks = mini(deathmark_stacks + stacks, 1000)
			update_status_box("Deathmark", deathmark_stacks, deathmark_tick_delay)
		else:
			deathmark_stacks = mini(deathmark_stacks + stacks, 1000)
			init_status_box("Deathmark", deathmark_stacks, deathmark_tick_delay, Color.DARK_RED)
		set_status_font_size("Deathmark", 40)


func berserk_effect():
	if berserk:
		berserk_time -= 1
		if berserk_time == 0:
			Global.bonus_strength -= 10
			Global.bonus_agility -= 15
			Global.stamina_regen_multi -= 1
			berserk = false

func river_effect():
		if river:
			if river_time % 30 == 0:
				if Global.health < Global.max_health:
					Global.health = minf(Global.health + 2, Global.max_health)
					player.update_hp_bar()
			river_time -= 1
			if river_time == 0:
				river_bg.end()
				river = false

func defensive_stance_effect():
	if defensive_stance > 0 :
		defensive_stance_time -= 1
		if defensive_stance_time == 0:
			Global.bonus_defense -= defensive_stance * 10
			defensive_stance = 0

func needle_effects():
	if needle_stacks >= 1 and needle_tick_delay == 0:
		needle_stacks = 0
	elif needle_stacks > 0:
		needle_tick_delay -= 1

func retribution_effects():
	if retribution_stacks >= 1 and retribution_tick_delay == 0:
		retribution_stacks = 0
	elif retribution_stacks > 0:
		retribution_tick_delay -= 1

func borrowed_time_effect():
	if borrowed_time:
		borrowed_time_tick_delay -= 1
		if borrowed_time_tick_delay == 0:
			player.update_hp_bar()
			borrowed_time = false

func fire_effect():
	if fire_stacks >= 1 and fire_tick_delay == 0:
		player.take_damage(fire_stacks / 2, 10, Color.DARK_ORANGE)
		update_status_box("Fire", fire_stacks, 15 * fire_stacks)
		fire_stacks -= 1
		fire_tick_delay = 15
	elif fire_tick_delay > 0:
		fire_tick_delay -= 1

func venom_effect():
	if venom_stacks >= 1 and venom_tick_delay == 0:
		player.take_damage(5, 25, Color.WEB_PURPLE)
		update_status_box("Venom", venom_stacks, 20 * venom_stacks)
		venom_stacks -= 1
		venom_tick_delay = 20
	elif venom_tick_delay > 0:
		venom_tick_delay -= 1

func shock_effects():
	var shock_loss = int(shock_stacks/10)
	
	if shock_stacks >= 1 and shock_tick_delay == 0:
		update_status_box("Shock", shock_stacks, shock_time_calc())
		shock_stacks -= maxi(1, shock_loss)
		shock_tick_delay = 10
	elif shock_tick_delay > 0:
		shock_tick_delay -= 1

func bleed_effects():
	if bleed_stacks >= 1 and bleed_tick_delay == 0:
		player.take_damage(float(Global.max_health/100), 1000, Color.DARK_RED)
		update_status_box("Bleeding", 1, 30 * bleed_stacks)
		bleed_stacks -= 1
		bleed_tick_delay = 30
	elif bleed_tick_delay > 0:
		bleed_tick_delay -= 1

func deathmark_effects():
	update_status_box("Deathmark", deathmark_stacks, deathmark_tick_delay)
	if deathmark_stacks == 1000:
		player.take_damage(float(Global.max_health/5), 1000, Color.BLACK)
		deathmark_tick_delay = 0
		deathmark_stacks = 0
	elif deathmark_stacks >= 1 and deathmark_tick_delay == 0:
		deathmark_stacks = 0
	elif deathmark_tick_delay > 0:
		deathmark_tick_delay -= 1

func _physics_process(_delta: float) -> void:
	berserk_effect()
	needle_effects()
	retribution_effects()
	borrowed_time_effect()
	river_effect()
	defensive_stance_effect()
	fire_effect()
	venom_effect()
	shock_effects()
	bleed_effects()
	deathmark_effects()

func shock_time_calc():
	var shock_current = shock_stacks
	var shock_loss = int(shock_current/10)
	var shock_ticks = 0
	
	while shock_current >= 1:
		shock_ticks += 1
		shock_loss = int(shock_current/10)
		shock_current -= maxi(1, shock_loss)
		
	return(shock_ticks * 10)
