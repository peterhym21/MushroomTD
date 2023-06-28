extends Node2D

var draw_outlines = false setget set_draw_outlines

var selector = preload("res://sprites/towers/tile_outline.png")

func set_draw_outlines(toggle):
	draw_outlines = toggle
	update()

func _draw():
	if draw_outlines:
		for cell in get_parent().get_used_cells():
			var pos = get_parent().map_to_world(cell) + Vector2(8, -4)
			draw_texture_rect(selector, Rect2(pos, Vector2(32, 32)), false, Color(1, 1, 1, 0.5))
