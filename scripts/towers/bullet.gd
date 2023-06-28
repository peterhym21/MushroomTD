extends Area2D

export var SPEED = 96
export var DAMAGE = 15

var velocity = Vector2()
var is_disabled = false

func _ready():
	add_to_group(global.GROUP_BULLET)
	
	connect("area_enter", self, "_on_area_enter")
	
	set_fixed_process(true)

func _on_area_enter(body):
	if not is_disabled:
		if body.is_in_group(global.GROUP_ENEMY):
			is_disabled = true
			body.take_damage(DAMAGE)
			queue_free()

func fire(target):
	velocity = (target - get_pos()).normalized() * SPEED

func _fixed_process(delta):
	set_pos(get_pos() + velocity * delta)

func _on_DeathTimer_timeout():
	queue_free()
