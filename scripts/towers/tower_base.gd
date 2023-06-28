extends StaticBody2D

export var NAME = "N/A"
export var COST = 20
export var RADIUS = 48

var smoke_scene = preload("res://scenes/effects/smoke.tscn")

var being_deleted = false
var being_carried = false setget set_being_carried
var offset = Vector2(0, -4)

signal being_carried_changed

func _ready():
	add_to_group(global.GROUP_TOWER)
	connect("input_event", self, "_on_tower_input_event")
	connect("mouse_enter", self, "_on_mouse_enter")
	connect("mouse_exit", self, "_on_mouse_exit")
	
	if RADIUS > 0:
		var node_colshape = get_node("Range/CollisionShape2D")
		node_colshape.set_shape(node_colshape.get_shape().duplicate())
		node_colshape.get_shape().set_radius(RADIUS)
		get_node("RangeIndicator").set_scale(Vector2(1, 1) * RADIUS / 48.0)

func _on_tower_input_event( viewport, event, shape_idx ):
	if not being_carried and not being_deleted:
		if event.type == InputEvent.MOUSE_BUTTON and event.pressed:
			if event.button_index == BUTTON_RIGHT:
				delete()
				get_tree().set_input_as_handled()

func delete():
	var main = util.get_main()
	if main.state == main.STATE_BUILD:
		being_deleted = true
		main.level.delete_tower(self)
		
		var e = smoke_scene.instance()
		e.set_pos(get_pos())
		get_parent().add_child(e)
		
		get_node("Anim").play("delete")
		yield(get_node("Anim"), "finished")
		queue_free()

func _on_mouse_enter():
	if not being_carried and RADIUS > 0:
		get_node("RangeIndicator").show()

func _on_mouse_exit():
	if not being_carried and RADIUS > 0:
		get_node("RangeIndicator").hide()

func get_tooltip():
	return "N/A"

func set_being_carried(toggle):
	being_carried = toggle
	
	emit_signal("being_carried_changed")
	
	if being_carried:
		get_node("Tower").set_opacity(0.5)
		get_node("Shadow").hide()
		get_node("Placer").show()
		if RADIUS > 0:
			get_node("RangeIndicator").show()
			get_node("Range").set_enable_monitoring(false)
		
	else:
		get_node("Tower").set_opacity(1)
		get_node("Anim").play("spawn")
		get_node("Shadow").show()
		get_node("Placer").hide()
		if RADIUS > 0:
			get_node("RangeIndicator").hide()
			get_node("Range").set_enable_monitoring(true)
