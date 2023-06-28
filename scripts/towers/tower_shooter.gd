extends "./tower_base.gd"

export(float) var FIRE_DELAY = 1
export(PackedScene) var BULLET_SCENE

var closest_enemy = null

func _ready():
	get_node("FireTimer").connect("timeout", self, "_on_FireTimer_timeout")
	get_node("FireTimer").set_wait_time(FIRE_DELAY)
	get_node("FireTimer").set_active(false)
	
	get_node("Range").connect("area_enter", self, "_on_area_enter")

func _on_FireTimer_timeout():
	#find closest enemy
	var distance = -1
	closest_enemy = null
	for enemy in get_node("Range").get_overlapping_areas():
		if enemy.is_in_group(global.GROUP_ENEMY):
			var d = (get_pos() + offset - enemy.get_pos()).length_squared()
			if d < distance or distance < 0:
				distance = d
				closest_enemy = enemy
	
	#fire bullet
	if closest_enemy != null:
		get_node("Anim").play("shoot")
		get_node("SFX").play("tower_shoot")
		get_node("SFX").voice_set_pitch_scale(0, rand_range(0.6, 1.0))
		
		var bullet = BULLET_SCENE.instance()
		bullet.set_pos(get_pos() + offset)
		get_parent().add_child(bullet)
		bullet.fire(closest_enemy.get_pos() + (closest_enemy.velocity * 0.33333))
		
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
	var bullet = BULLET_SCENE.instance()
	var t = """%s
	Cost: %d
	Range: %d
	Damage: %d
	    Fires a projectile at the closest enemy within its range.""" %[NAME, COST, RADIUS, bullet.DAMAGE]
	bullet.free()
	
	return t
