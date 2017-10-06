var grid_start_x
var grid_start_y
var grid_end_x
var grid_end_y

func _init(width, height):

	self.grid_start_x = 0
	self.grid_start_y = 0
	self.grid_end_x = width
	self.grid_end_y = height
	
func simple_marching_squares(tile_map, fill_tile, opposing, fill_group, internal = false):
	if internal and not fill_group.has(fill_tile):
		fill_group.append(fill_tile)
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if fill_tile == tile_map.get_cell(x, y):
				var score = 0
				if internal:
					score = get_internal_corner_score(tile_map, x, y, fill_group)
				else:
					score = get_corner_score(tile_map, x, y, opposing) 
				tile_map.set_cell(x, y, fill_group[score])

func get_corner_score(tile_map, x, y, opposing):
	var score = 0
	
	var tp = tile_map.get_cell(x, y - 1) == opposing
	var bm = tile_map.get_cell(x, y + 1) == opposing
	var lt = tile_map.get_cell(x - 1, y) == opposing
	var rt = tile_map.get_cell(x + 1, y) == opposing
	var br = tile_map.get_cell(x + 1, y + 1) == opposing
	var bl = tile_map.get_cell(x - 1, y + 1) == opposing
	var tr = tile_map.get_cell(x + 1, y - 1) == opposing
	var tl = tile_map.get_cell(x - 1, y - 1) == opposing
	
	if br or rt or bm:
		score += 1
	
	if bl or lt or bm:
		score += 2
	
	if tr or rt or tp:
		score += 4
	
	if tl or lt or tp:
		score += 8
	
	return score
	
func get_internal_corner_score(tile_map, x, y, fill_group):
	var score = 0
	
	var tp = 1 if not fill_group.has(tile_map.get_cell(x,     y - 1)) else 0
	var bm = 1 if not fill_group.has(tile_map.get_cell(x,     y + 1)) else 0
	var lt = 1 if not fill_group.has(tile_map.get_cell(x - 1, y    )) else 0
	var rt = 1 if not fill_group.has(tile_map.get_cell(x + 1, y    )) else 0
	var br = 1 if not fill_group.has(tile_map.get_cell(x + 1, y + 1)) else 0
	var bl = 1 if not fill_group.has(tile_map.get_cell(x - 1, y + 1)) else 0
	var tr = 1 if not fill_group.has(tile_map.get_cell(x + 1, y - 1)) else 0
	var tl = 1 if not fill_group.has(tile_map.get_cell(x - 1, y - 1)) else 0
	
	if (br + rt + bm) >= 1:
		score += 1
	
	if (bl + lt + bm) >= 1:
		score += 2
	
	if (tr + rt + tp) >= 1:
		score += 4
	
	if (tl + lt + tp) >= 1:
		score += 8
	
	return score
