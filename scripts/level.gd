extends Node2D

export var LEVEL_NUMBER = 0

onready var map = preload("res://scripts/map/map.gd").new(self, get_node("Floor"))
onready var tilemap = get_node("Floor")
onready var objects = get_node("Objects")

var paths = []
var startindex = 0

var level_rect

export var WAVE_TOTAL = 1
var current_wave = 0

func _ready():
	for startpos in map.starts:
		var start = preload("res://scenes/objectives/start.tscn").instance()
		start.set_pos(map_to_world(startpos))
		add_child(start)
		move_child(start, 0)
	
	var end = preload("res://scenes/objectives/end.tscn").instance()
	end.set_pos(map_to_world(map.end))
	add_child(end)
	move_child(end, 0)
	move_child(tilemap, 0)
	make_path()
	
	for cell in tilemap.get_used_cells():
		var pos = tilemap.map_to_world(cell) + Vector2(8, -4)
		if level_rect == null:
			level_rect = Rect2(pos, Vector2(1, 1))
		else:
			level_rect = level_rect.expand(pos)
	level_rect.size += Vector2(32, 40)
	
	get_node("Back").create_background()
	
#	call_deferred("capture_screenshot")

func capture_screenshot():
	# Get a screenshot of the level, crop it, and save it
	# For use with the level select icons
	get_viewport().queue_screen_capture()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	var screenshot = get_viewport().get_screen_capture()
	var screenshot_rect = level_rect
	screenshot_rect.pos = (get_viewport().get_rect().size * 0.5) - (screenshot_rect.size * 0.5)
	
	var img = Image(level_rect.size.width, level_rect.size.height, false, Image.FORMAT_RGB)
	img.blit_rect(screenshot, screenshot_rect, Vector2())
	img.save_png("res://sprites/levels/level" + str(LEVEL_NUMBER) + ".png")

func add_tower(tower):
	var pos = world_to_map(tower.get_pos())
	if map.can_place_tower(pos):
		var placed_tower = tower.duplicate()
		objects.add_child(placed_tower)
		placed_tower.being_carried = false
		get_parent().add_coins(-tower.COST)
		
		map.remove_point(pos)
		make_path()

func delete_tower(tower):
	if get_parent().state == get_parent().STATE_BUILD:
		var pos = world_to_map(tower.get_pos())
		get_parent().add_coins(tower.COST)
		
		map.add_point(pos)
		make_path()

func make_path():
	if not paths.empty():
		for p in paths:
			for cell in p:
				tilemap.set_cellv(cell, 0)
		
		paths.clear()
	
	for startpos in map.starts:
		paths.append(map.get_point_path(startpos, map.end))
	
	for p in paths:
		for cell in p:
			tilemap.set_cellv(cell, 1)
	
	get_parent().get_node("HUD").check_can_wave_start()

func spawn_next_wave():
	if current_wave < WAVE_TOTAL:
		get_node("WavePlayer").play("wave" + str(current_wave))
		get_parent().set_state(get_parent().STATE_WAVE)
		current_wave += 1

func spawn_enemy(type):
	var enemy = load("res://scenes/enemies/enemy_" + type + ".tscn").instance()
	enemy.set_pos(map_to_world(map.starts[startindex]))
	enemy.path = paths[startindex]
	enemy.connect("death", self, "_on_enemy_death", [enemy])
	get_node("Objects").add_child(enemy)
	
	startindex = (startindex + 1) % paths.size()

func _on_enemy_death(enemy):
	globalsamples.play("coinget")
	get_parent().add_coins(enemy.COINS)
	get_parent().add_score(enemy.COINS)
	call_deferred("check_wave_end")

func set_lose():
	get_tree().call_group(get_tree().GROUP_CALL_DEFAULT, global.GROUP_ENEMY, "queue_free")
	get_node("WavePlayer").stop()

func check_wave_end():
	yield(get_tree(), "fixed_frame")
	if get_tree().get_nodes_in_group(global.GROUP_ENEMY).empty() and not get_node("WavePlayer").is_playing():
		if not get_parent().state == get_parent().STATE_LOSE:
			if current_wave < WAVE_TOTAL:
				get_parent().set_state(get_parent().STATE_BUILD)
			else:
				get_parent().set_state(get_parent().STATE_WIN)

func can_start_wave():
	if get_parent().state != get_parent().STATE_BUILD:
		return false
	
	if paths.empty():
		return false
	
	for p in paths:
		if p.size() == 0:
			return false
	
	return true

func snap_to_map(pos):
	return map_to_world(tilemap.world_to_map(pos))

func map_to_world(pos):
	return tilemap.map_to_world(pos) + (tilemap.get_cell_size() * 0.5)

func world_to_map(pos):
	return tilemap.world_to_map(pos)

func get_world_path(start, end):
	var path = map.get_point_path(world_to_map(start), world_to_map(end))
	for i in range(path.size()):
		path[i] = map_to_world(path[i])
	
	return path
