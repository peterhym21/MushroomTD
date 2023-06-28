extends Node

const GROUP_ENEMY = "Enemy"
const GROUP_BULLET = "Bullet"
const GROUP_TOWER = "Tower"

var settings = {
	sfx = 0.7,
	music = 1
}

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_settings()

func save_settings():
	var savefile = ConfigFile.new()
	savefile.set_value("audio", "sfx", settings.sfx)
	savefile.set_value("audio", "music", settings.music)
	savefile.save("user://settings.cfg")

func load_settings():
	var savefile = ConfigFile.new()
	var err = savefile.load("user://settings.cfg")
	if err == OK:
		settings.sfx = savefile.get_value("audio", "sfx")
		settings.music = savefile.get_value("audio", "music")