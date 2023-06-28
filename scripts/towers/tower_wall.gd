extends "./tower_base.gd"

func _ready():
	get_node("Range").set_enable_monitoring(false)
	get_node("RangeIndicator").hide()

func get_tooltip():
	var t = """%s
	Cost: %d
	    A Mushroom that only blocks enemy movement.""" %[NAME, COST]
	
	return t
