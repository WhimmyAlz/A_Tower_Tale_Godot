extends Control

var BAR_HOVER := -1
var BAR_HOVER_t := 100

func hover_bars():
	position.y += (BAR_HOVER * 0.1)
	BAR_HOVER_t -= 1
	if BAR_HOVER_t == 0:
		BAR_HOVER *= -1
		BAR_HOVER_t = 100
	
func Update_HP():
	@warning_ignore("integer_division", "narrowing_conversion")
	$HP_BAR.value = maxi(100 * Global.health / Global.max_health, 0)

func Update_STAM():
	@warning_ignore("integer_division", "narrowing_conversion")
	$STAM_BAR.value = maxi(100 * Global.stamina / Global.max_stamina , 0)

func Update_XP():
	@warning_ignore("integer_division")
	$PXP_BAR.value = maxi(100 * Global.player_XP / Global.player_XP_REQ, 0)

func _physics_process(_delta: float) -> void:
	hover_bars()
