
var owner
var tile_map = []
var astar_map = load("res://scripts/map/astar2d.gd").new()
var rect = Rect2()

var starts = []
var end

var neighbor_directions = [
	Vector2(1, 0),
	Vector2(1, -1),
	Vector2(0, -1),
	Vector2(-1, 0),
	Vector2(-1, 1),
	Vector2(0, 1)
]

func _init(_owner, _tilemap):
	self.owner = _owner
	build_map(_tilemap)

func build_map(tilemap):
	var used_cells = tilemap.get_used_cells()
	
	# Create map
	for cell in used_cells:
		var cellid = used_cells.find(cell)
		
		if tilemap.get_cellv(cell) == 2:
			starts.append(cell)
		elif tilemap.get_cellv(cell) == 3:
			end = cell
		
		rect = rect.expand(cell)
		astar_map.add_point(cellid, cell)
	rect.size += Vector2(1, 1)
	
	for x in range(rect.size.x):
		tile_map.append([])
		for y in range(rect.size.y):
			var id = astar_map.get_point_id(Vector2(x,y) + rect.pos)
			var walkable = tilemap.get_cellv(Vector2(x,y) + rect.pos) != -1
			tile_map[x].append(tile.new(id, walkable))
	
	# Add connections
	for cell in used_cells:
		var cellid = astar_map.get_point_id(cell)
		connect_neighbors(cellid, cell)

func add_point(map_pos):
	var cellid = astar_map.get_available_point_id()
	astar_map.add_point(cellid, map_pos)
	
	var tile = get_tile(map_pos)
	tile.id = cellid
	tile.is_walkable = true
	
	connect_neighbors(cellid, map_pos)

func remove_point(map_pos):
	var tile = get_tile(map_pos)
	astar_map.remove_point(tile.id)
	
	var tile = get_tile(map_pos)
	tile.id = -1
	tile.is_walkable = false

func connect_neighbors(cellid, cellpos):
	for dir in neighbor_directions:
		var check_cell = cellpos + dir
		if rect.has_point(check_cell):
			var tile = get_tile(check_cell)
			if tile.is_walkable and not astar_map.are_points_connected(cellid, tile.id):
				astar_map.connect_points(cellid, tile.id)

func get_tile(pos):
	pos = pos - rect.pos
	return tile_map[pos.x][pos.y]

func can_place_tower(pos):
	if rect.has_point(pos) and get_tile(pos).is_walkable:
		for dir in neighbor_directions:
			for s in starts:
				if pos == s + dir:
					return false
			if pos == end + dir:
				return false
		
		return not starts.has(pos) and pos != end
	
	return false

func get_point_path(start, end):
	return astar_map.get_path(get_tile(start).id, get_tile(end).id)

class tile:
	var id = -1
	var is_walkable = false
	
	func _init(_id, _is_walkable):
		self.id = _id
		self.is_walkable = _is_walkable
