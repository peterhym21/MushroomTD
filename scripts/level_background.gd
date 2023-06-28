extends TileMap

func create_background():
	for cell in get_parent().tilemap.get_used_cells():
		get_node("Shadow").set_cellv(cell, 4)
	
	fill_cells(get_node("Shadow"), 3, 100)
	fill_cells(self, 2, 25)
	fill_cells(self, 1, 50)
	fill_cells(self, 0, 75)

func fill_cells(tmap, tile, chance):
	var neighbor = get_parent().map.neighbor_directions
	for cell in tmap.get_used_cells():
		for dir in neighbor:
			var ncell = cell + dir
			if tmap.get_cellv(ncell) == -1:
				if randi()%100 < chance:
					set_cellv(ncell, tile)
	
