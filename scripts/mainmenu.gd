extends Control

func _ready():
	musicplayer.start()
	
	global.load_settings()
	get_node("Options/VBoxContainer/SoundSlider").set_value(global.settings.sfx * 10)
	get_node("Options/VBoxContainer/MusicSlider").set_value(global.settings.music * 10)

func _on_StartButton_pressed():
	globalsamples.play("button")
	global.save_settings()
	loader.goto_scene(preload("res://scenes/gui/levelselect.tscn"))

func _on_InfoButton_toggled( pressed ):
	globalsamples.play("button")
	get_node("HowTo").set_hidden(not pressed)

func _on_OptionsButton_toggled( pressed ):
	globalsamples.play("button")
	get_node("Options").set_hidden(not pressed)

func _on_QuitButton_pressed():
	global.save_settings()
	get_tree().quit()

func _on_SoundSlider_value_changed( value ):
	var v = value * 0.1
	global.settings.sfx = v
	AS.set_fx_global_volume_scale(v)

func _on_MusicSlider_value_changed( value ):
	var v = value * 0.1
	global.settings.music = v
	AS.set_stream_global_volume_scale(v)
