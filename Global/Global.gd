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
var health_regen_multi : float = 10
var stamina_regen_multi : float = 0
var power_multi : float = 0
var defense_booster : float = 0
var defense_penetration_adds : float = 0

# Misc
var Gravity := 50
var stun_time := 0

## Sets stats for Brawler [class:0]
func class_stats_brawler():
	flight = 0
	max_jumps = 1 + jump_adds
	jump_power = round(1500 * (1 + jump_multi))
	jump_limit = 100 # must be more than 0

	player_spd = round((15 + agility) * (1 + speed_multi))
	player_weight = 20

	max_health = 280
	max_stamina = 120

	power = round(18 * (1 + power_multi))
	defense = 0
	defense_penetration = 0
	
	strength = 4 + bonus_strength
	agility = 1 + bonus_agility
	dexterity = 2 + bonus_dexterity
	intellect = 1 + bonus_intellect

## Sets stats for Draco [class:10]
func class_stats_draco():
	flight = 1
	max_jumps = 12 + (jump_adds * 3)
	jump_power = round(1050 * (1 + jump_multi))
	jump_limit = 350 # must be more than 0

	player_spd = round((14 + agility) * (1 + speed_multi))
	player_weight = 30

	max_health = 150
	max_stamina = 320

	power = round(35 * (1 + power_multi))
	defense = 0
	defense_penetration = 0

	strength = 4 + bonus_strength
	agility = 4 + bonus_agility
	dexterity = 4 + bonus_dexterity
	intellect = 4 + bonus_intellect

func _ready() -> void:
	health = max_health

func _physics_process(_delta: float):
	if player_class == 0:
		class_stats_brawler()

	elif player_class == 10:
		class_stats_draco()
