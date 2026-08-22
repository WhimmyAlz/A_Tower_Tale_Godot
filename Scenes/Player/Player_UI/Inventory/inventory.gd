extends Node2D

# Needed stats: Level, xp, Health, Stamina, Power, Crit Rate, Crit Damage, STR, AGI, INT, DEF, DPEN, HP Regen, STAM Regen, Jumps
@onready
var level_label = $stastList/VBoxContainer/Level

@onready
var stats_label = $stastList/VBoxContainer/stats

func update_stats():
	# stats
	var health = Global.health
	var max_health = Global.max_health
	var stamina = Global.stamina
	var max_stamina = Global.max_stamina
	var power = Global.power
	var crit_rate = Global.crit_chance
	var crit_damage = Global.crit_damage
	var strength = Global.strength
	var agility = Global.agility
	
	# displayed texts
	var listed_stats = [
	"Exp: %s/%s" % [Global.player_XP, Global.player_XP_REQ],
	"Health:" + str(health) + "/" + str(max_health),
	"Stamina:" + str(stamina) + "/" + str(max_stamina),
	"Power:" + str(power),
	"Crit Rate:" + str(crit_rate),
	"Crit Damage:" + str(crit_damage),
	"STR:" + str(strength),
	"AGI:" + str(agility)
	]
	
	level_label.text = "Level: %s" % Global.player_Level
	
	stats_label.text = ""
	for i in range(len(listed_stats)):
		stats_label.text += listed_stats[i] + "[br]"

func _ready() -> void:
	update_stats()
	
func _physics_process(_delta: float) -> void:
	update_stats()
