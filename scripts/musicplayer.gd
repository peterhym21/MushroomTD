extends StreamPlayer

func start():
	if not is_playing():
		set_stream(preload("res://music/fabric.ogg"))
		set_loop(true)
		play()
