extends "./tower_base.gd"

export(float) var FIRE_DELAY = 0.5
export var DAMAGE = 5

func _ready():
	get_node("FireTimer").connect("timeout", self, "_on_FireTimer_timeout")
	get_node("FireTimer").set_wait_time(FIRE_DELAY)
	get_node("FireTimer").set_active(false)
	
	get_node("Range").connect("area_enter", self, "_on_area_enter")
	
func _on_FireTimer_timeout():
	var overlap = get_node("Range").get_overlapping_areas()
	if not overlap.empty():
		get_node("Anim").play("shoot")
		get_node("SFX").play("tower_poison")
		get_node("SFX").voice_set_pitch_scale(0, rand_range(0.6, 1.0))
		
		for body in overlap:
			if body.is_in_group(global.GROUP_ENEMY):
				body.take_damage(DAMAGE)
		
	elif get_node("Range").get_overlapping_areas().empty():
		get_node("FireTimer").stop()
		get_node("FireTimer").set_active(false)

func _on_area_enter(area):
	if area.is_in_group(global.GROUP_ENEMY):
		if not get_node("FireTimer").is_active():
			get_node("FireTimer").set_active(true)
			get_node("FireTimer").start()
			call_deferred("_on_FireTimer_timeout")

func get_tooltip():
	var t = """%s
	Cost: %d
	Range: %d
	Damage: %d
	    Deals damage to all enemies within its range.""" %[NAME, COST, RADIUS, DAMAGE]
	
	return t
