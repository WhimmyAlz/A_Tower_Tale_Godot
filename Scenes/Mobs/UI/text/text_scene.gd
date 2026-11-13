extends Panel

@export var lifetime = 300
@export var color = "color=white"
@export var text = ""

func reset_mod():
	modulate.a = 0

func _ready() -> void:
	reset_mod()
	$RichTextLabel.text = "[%s][i]%s[/i][/color]" % [color, text]

func set_color(val):
	color = "color=%s" % val

func set_text(txt):
	text = txt

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	lifetime -= 1
	
	if lifetime <= 100:
		modulate.a -= 0.01
	elif modulate.a < 1:
		modulate.a += 0.01
	
	if lifetime == 0:
		queue_free()
