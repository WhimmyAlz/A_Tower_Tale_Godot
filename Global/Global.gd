extends Node

var floors := 0

var player_class := 0
var player_XP := 0
var player_XP_REQ := 100
var player_Level := 1

var max_jumps := 1
var flight := 0
var jump_power := 1500
var jump_limit := 100

var player_spd := 10
var player_weight := 50
var player_dir := 1

# Combat stats
var strength := 2
var agility := 2
var dexterity := 2
var intellect := 2

var bonus_strength := 0
var bonus_agility := 0
var bonus_dexterity := 0
var bonus_intellect := 0

var power := 0 # damage % is based on this
var defense := 0 # reduces damage by 1 (min 1)
var defense_penetration := 0 # ignores X amount of defense
var max_stamina := 1.0
var stamina := 1.0
var max_health := 100.0
var health := 100.0
var health_regen_value := 15.0 # % of max health healed naturally per floor
var crit_chance := 0.0 # chance to land crit
var crit_damage := 25.0 # extra damage % from crits

# cooldowns
var attack1t := 0
var attack2t := 0
var attack3t := 0
var attack4t := 0
var attack5t := 0
var ultimatet := 0

var attack1_max_t
var attack2_max_t
var attack3_max_t
var attack4_max_t
var attack5_max_t
var ultimate_max_t

# Buffs
var speed_multi : float = 0
var jump_multi : float = 0
var jump_adds : int = 0
var bonus_health_regen : float = 0
var stamina_regen_multi : float = 0
var bonus_power : int = 0
var bonus_defense : int = 0
var defense_penetration_adds : int = 0

# Misc
var Gravity := 50
var stun_time := 0

## Sets stats for Brawler [class:0]
func class_stats_brawler():
	flight = 0
	max_jumps = 1 + jump_adds
	jump_power = round(1500 * (1 + jump_multi))
	jump_limit = 100 # must be more than 0

	player_spd = round(agility * (1 + speed_multi))
	player_weight = 20

	max_health = 400
	max_stamina = 120

	power = 18 + bonus_power
	defense = 5 + bonus_defense
	defense_penetration = 0 + defense_penetration_adds
	
	strength = 4 + bonus_strength
	agility = 12 + bonus_agility
	dexterity = 2 + bonus_dexterity
	intellect = 1 + bonus_intellect

## Sets stats for Draco [class:10]
func class_stats_draco():
	flight = 1
	max_jumps = 12 + (jump_adds * 3)
	jump_power = round(1050 * (1 + jump_multi))
	jump_limit = 350 # must be more than 0

	player_spd = round(agility * (1 + speed_multi))
	player_weight = 30

	max_health = 250
	max_stamina = 320

	power = 35 + bonus_power
	defense = 15
	defense_penetration = 0 + defense_penetration_adds

	strength = 4 + bonus_strength
	agility = 10 + bonus_agility
	dexterity = 4 + bonus_dexterity
	intellect = 4 + bonus_intellect

func _ready() -> void:
	class_stats_brawler()
	health = max_health

func _physics_process(_delta: float):
	if player_class == 0:
		class_stats_brawler()

	elif player_class == 10:
		class_stats_draco()
