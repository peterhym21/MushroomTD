extends Button

export var LEVEL_NUM = 0

func _ready():
	get_node("Label").set_text("Level " + str(LEVEL_NUM))
	get_node("Panel/TextureFrame").set_texture(load("res://sprites/levels/level" + str(LEVEL_NUM) + ".png"))
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	globalsamples.play("button")
	loader.goto_level(load("res://scenes/levels/level" + str(LEVEL_NUM) + ".tscn"))
