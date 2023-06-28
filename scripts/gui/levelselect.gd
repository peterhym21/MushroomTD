extends Control

var mainmenuscene = load("res://scenes/mainmenu.tscn")

func _ready():
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		loader.goto_scene(mainmenuscene)

func _on_BackButton_pressed():
	globalsamples.play("button")
	loader.goto_scene(mainmenuscene)
