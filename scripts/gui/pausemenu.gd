extends PopupPanel

func _ready():
	connect("about_to_show", self, "_on_about_to_show")
	connect("popup_hide", self, "_on_popup_hide")

func set_win():
	get_node("VBoxContainer/Label").set_text("YOU WIN")
	get_node("VBoxContainer/Score").show()
	get_node("VBoxContainer/Score").set_text("Score: %03d !" % util.get_main().score)

func set_lose():
	get_node("VBoxContainer/Label").set_text("YOU LOSE")

func _on_about_to_show():
	set_pos((get_parent().get_size() * 0.5) - (get_size() * 0.5))
	get_tree().set_pause(true)
	set_process_input(true)

func _on_popup_hide():
	set_process_input(false)
	get_tree().set_pause(false)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		globalsamples.play("button")
		hide()
		get_tree().set_input_as_handled()

func _on_ResumeButton_pressed():
	globalsamples.play("button")
	hide()

func _on_RestartButton_pressed():
	globalsamples.play("button")
	hide()
	loader.restart_level()

func _on_MainMenuButton_pressed():
	globalsamples.play("button")
	hide()
	loader.goto_scene(preload("res://scenes/mainmenu.tscn"))
