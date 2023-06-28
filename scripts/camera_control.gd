extends Camera2D

var smooth_zoom = 0.5
var target_zoom = 0
var zoom_levels = [1, 0.5, 0.25]

const ZOOM_MARGIN = 0.001
const ZOOM_SPEED = 30

func _ready():
	call_deferred("_post_ready")

func _post_ready():
	var levelrect = util.get_main().level.level_rect
	var pos = levelrect.pos + (levelrect.size * 0.5) + Vector2(0.1, 0.1)
	set_pos(pos)
	
	get_viewport().connect("size_changed", self, "update_limits")
	set_zoom(Vector2(1, 1) * zoom_levels[target_zoom])
	update_limits()
	
	set_process_input(true)

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION and event.button_mask == BUTTON_MASK_MIDDLE:
		var pos = get_pos() - (event.relative_pos * get_zoom())
		var viewsize = get_viewport_rect().size * get_zoom()
		pos.x = clamp(pos.x, get_limit(MARGIN_LEFT) + viewsize.x * 0.5, get_limit(MARGIN_RIGHT) - viewsize.x * 0.5)
		pos.y = clamp(pos.y, get_limit(MARGIN_TOP) + viewsize.y * 0.5, get_limit(MARGIN_BOTTOM) - viewsize.y * 0.5)
		
		set_pos(pos)
		set_offset(pos.floor() - pos)
	
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_WHEEL_UP and event.pressed:
		target_zoom = clamp(target_zoom + 1, 0, 2)
		set_zoom(Vector2(1, 1) * zoom_levels[target_zoom])
		update_limits()
		
	elif event.type == InputEvent.MOUSE_BUTTON and event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
		target_zoom = clamp(target_zoom - 1, 0, 2)
		set_zoom(Vector2(1, 1) * zoom_levels[target_zoom])
		update_limits()

func update_limits():
	var viewrect = get_viewport_rect()
	var levelrect = util.get_main().level.level_rect
	
	levelrect.pos -= (viewrect.size * 0.5 * get_zoom())
	levelrect.size += (viewrect.size * get_zoom())
	
	set_limit(MARGIN_RIGHT, levelrect.pos.x + levelrect.size.x)
	set_limit(MARGIN_TOP, levelrect.pos.y)
	set_limit(MARGIN_LEFT, levelrect.pos.x)
	set_limit(MARGIN_BOTTOM, levelrect.pos.y + levelrect.size.y)
