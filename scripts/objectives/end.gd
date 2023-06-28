extends Area2D

func _ready():
	connect("area_enter", self, "_on_area_enter")

func _on_area_enter(body):
	if body.is_in_group(global.GROUP_ENEMY):
		get_node("SFX").play("player_hurt")
		util.get_main().take_damage(body.DAMAGE)
		util.get_main().add_score(-body.COINS)
		body.queue_free()
		get_parent().call_deferred("check_wave_end")
