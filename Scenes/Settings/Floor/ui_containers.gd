extends Control


func make_text(txt, clr="white"):
	var text = preload("res://Scenes/Mobs/UI/text/textScene.tscn").instantiate()
	text.set_text(txt)
	text.set_color(clr)
	$text_container.add_child(text)
