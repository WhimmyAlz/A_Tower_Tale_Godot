extends Node2D

# Needed stats: Level, xp, Health, Stamina, Power, Crit Rate, Crit Damage, STR, AGI, INT, DEF, DPEN, HP Regen, STAM Regen, Jumps
@onready
var stats_label = $stastList/stats

func update_stats():
	# displayed texts
	var listed_stats = [
	"[b]Level %s[/b]\n" % Global.player_Level,
	"Exp %d\n\n" % Global.player_XP,
	"Health: %d/%d\n" % [Global.health, Global.max_health],
	"Stamina: %d/%d\n\n" % [Global.stamina, Global.max_stamina],
	"Crit Rate: %.1f%%\n" % Global.crit_chance,
	"Crit Damage: %.1f%%\n\n" % (Global.crit_damage * 100),
	"Power: %d\n" % Global.power,
	"Strength: %d\n" % Global.strength,
	"Dexterity: %d\n" % Global.dexterity,
	"Intellect: %d\n" % Global.intellect,
	"Agility: %d\n\n" % Global.agility,
	"Defense: %d\n" % Global.defense,
	"Defense penetration: %d\n\n" % Global.defense_penetration,
	"Health regen: %d%%\n" % Global.health_regen_value,
	"Stamina regen: %.01fx\n\n" % (1 + Global.stamina_regen_multi),
	"Player weight: %d\n" % Global.player_weight,
	"Max jumps: %d" % Global.max_jumps,
	]
	
	stats_label.text = listed_stats[0]
	for i in range(1, len(listed_stats)):
		stats_label.text += listed_stats[i]

func toggle_inventory():
		if self.visible:
			self.visible = false
		else:
			self.visible = true

func _ready() -> void:
	update_stats()
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory()
	update_stats()
