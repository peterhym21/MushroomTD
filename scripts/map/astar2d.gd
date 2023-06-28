extends AStar

# All input and output is Vector2D

func add_point(id, pos, weight_scale=1):
	return .add_point(id, util.Vec2to3(pos), weight_scale)

func get_point_id(pos):
	return .get_closest_point(util.Vec2to3(pos))

func get_path(id_start, id_end):
	var path = Array(get_point_path(id_start, id_end))
	for p in path:
		path[path.find(p)] = util.Vec3to2(p)
	
	return Vector2Array(path)
