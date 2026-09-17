extends Node2D

@onready var player = get_parent().get_parent().get_body()

var preload_status_box = preload("res://Scenes/Player/Player_UI/Status_effects/status_effect_box.tscn")
var status_box

var berserk = false
var berserk_time := 0

var needle_stacks = 0
var needle_tick_delay := 0

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

func init_status_box(status, status_level, time, color):
	status_box = preload_status_box.instantiate()
	status_box.set_status(status)
	status_box.set_status_level(status_level)
	status_box.set_time(time)
	status_box.set_color(color)
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

func get_shock():
	return(shock_stacks)

func get_needles():
	return(needle_stacks)

func remove_needles(stacks):
	needle_stacks -= stacks
	if needle_stacks <= 0:
		needle_tick_delay = 1
	update_status_box("Needle Stacks", needle_stacks, needle_tick_delay)


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
			update_status_box("Venom", venom_stacks, 10 * venom_stacks)
		else:
			venom_stacks = mini(venom_stacks + stacks, 30)
			init_status_box("Venom", venom_stacks, 10 * venom_stacks, Color.PURPLE)

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

func needle_effects():
	update_status_box("Needle Stacks", needle_stacks, needle_tick_delay)
	if needle_stacks >= 1 and needle_tick_delay == 0:
		needle_stacks = 0
	elif needle_stacks > 0:
		needle_tick_delay -= 1

func fire_effect():
	if fire_stacks >= 1 and fire_tick_delay == 0:
		fire_stacks -= 1
		player.take_damage(fire_stacks / 2, 10)
		update_status_box("Fire", fire_stacks, 15 * fire_stacks)
		fire_tick_delay = 15
	elif fire_tick_delay > 0:
		fire_tick_delay -= 1

func venom_effect():
	if venom_stacks >= 1 and venom_tick_delay == 0:
		venom_stacks -= 1
		player.take_damage(5, 25)
		update_status_box("Venom", venom_stacks, 15 * venom_stacks)
		venom_tick_delay = 10
	elif venom_tick_delay > 0:
		venom_tick_delay -= 1

func shock_effects():
	var shock_loss = int(shock_stacks/10)
	
	if shock_stacks >= 1 and shock_tick_delay == 0:
		shock_stacks -= maxi(1, shock_loss)
		update_status_box("Shock", shock_stacks, shock_time_calc())
		shock_tick_delay = 10
	elif shock_tick_delay > 0:
		shock_tick_delay -= 1

func bleed_effects():
	if bleed_stacks >= 1 and bleed_tick_delay == 0:
		bleed_stacks -= 1
		bleed_tick_delay = 30
		player.take_damage(float(Global.max_health/100), 1000)
		update_status_box("Bleeding", 1, 30 * bleed_stacks)
	elif bleed_tick_delay > 0:
		bleed_tick_delay -= 1

func deathmark_effects():
	update_status_box("Deathmark", deathmark_stacks, deathmark_tick_delay)
	if deathmark_stacks == 1000:
		player.take_damage(float(Global.max_health/5), 1000)
		deathmark_tick_delay = 0
		deathmark_stacks = 0
	elif deathmark_stacks >= 1 and deathmark_tick_delay == 0:
		deathmark_stacks = 0
	elif deathmark_tick_delay > 0:
		deathmark_tick_delay -= 1

func _physics_process(_delta: float) -> void:
	berserk_effect()
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
