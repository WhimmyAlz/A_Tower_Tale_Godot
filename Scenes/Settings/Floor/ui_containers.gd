extends Control


func make_text(txt, clr="white", quick_text=true):
	var text = preload("res://Scenes/Mobs/UI/text/textScene.tscn").instantiate()
	text.set_text(txt)
	text.set_color(clr)
	text.set_quick_text(quick_text)
	$text_container.add_child(text)
