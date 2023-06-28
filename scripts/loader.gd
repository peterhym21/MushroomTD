extends CanvasLayer

var current_level
var is_loading = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func goto_scene(scene):
	if not is_loading:
		is_loading = true
		
		get_node("Control").show()
		get_node("Anim").play("close")
		yield(get_node("Anim"), "finished")
		
		get_tree().change_scene_to(scene)
		
		get_node("Anim").play_backwards("close")
		yield(get_node("Anim"), "finished")
		get_node("Control").hide()
		
		is_loading = false

func goto_level(level):
	if not is_loading:
		current_level = level
		goto_scene(preload("res://scenes/main.tscn"))

func restart_level():
	goto_level(current_level)
