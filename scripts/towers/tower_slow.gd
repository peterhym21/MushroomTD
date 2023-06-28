extends "./tower_base.gd"

export var SLOW = 0.5

func _ready():
	get_node("Range").connect("area_enter", self, "_on_area_enter")
	get_node("Range").connect("area_exit", self, "_on_area_exit")

func _on_area_enter(body):
	if body.is_in_group(global.GROUP_ENEMY):
		get_node("Anim").play("shoot")
		body.add_slow(get_instance_ID(), SLOW)

func _on_area_exit(body):
	if body.is_in_group(global.GROUP_ENEMY):
		body.remove_slow(get_instance_ID())

func get_tooltip():
	var t = """%s
	Cost: %d
	Range: %d
	    Slows all enemy movement by %d%% within its range.""" %[NAME, COST, RADIUS, (1-SLOW) * 100]
	
	return t
