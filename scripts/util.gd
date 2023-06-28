extends Node

static func Vec2to3(vec):
	return Vector3(vec.x, vec.y, 0)

static func Vec3to2(vec):
	return Vector2(vec.x, vec.y)

func get_main():
	return get_tree().get_root().get_node("Main")
