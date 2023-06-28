extends Button

export(PackedScene) var TOWER_SCENE

var texture
var tooltip_text

func _ready():
	var tower = TOWER_SCENE.instance()
	texture = tower.get_node("Tower").get_texture()
	tooltip_text = tower.get_tooltip()
	tower.free()
	
	connect("mouse_enter", self, "_on_mouse_enter")
	connect("mouse_exit", self, "_on_mouse_exit")

func _on_mouse_enter():
	util.get_main().get_node("HUD").show_tooltip(self)

func _on_mouse_exit():
	util.get_main().get_node("HUD").hide_tooltip()

func _draw():
	var texsize = texture.get_size() * 0.5
	var pos = (get_size() * 0.5) - (texsize * 0.5)
	draw_texture_rect(texture, Rect2(pos, texsize), false)
