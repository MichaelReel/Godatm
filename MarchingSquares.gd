var grid_start_x
var grid_start_y
var grid_end_x
var grid_end_y

func _init(width, height):

	self.grid_start_x = 0
	self.grid_start_y = 0
	self.grid_end_x = width
	self.grid_end_y = height
	
func simple_marching_squares(tile_map, fill_group, opposing_group, internal = false):
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if fill_group.has(tile_map.get_cell(x, y)):
				var test_group = fill_group if internal else opposing_group
				var score = get_corner_score(tile_map, x, y, test_group, internal)
				tile_map.set_cell(x, y, fill_group[score])

func get_corner_score(tile_map, x, y, fill_group, internal):
	var score = 0
	
	var match   = 0 if internal else 1
	var nomatch = 1 if internal else 0
	
	var tp = match if fill_group.has(tile_map.get_cell(x,     y - 1)) else nomatch
	var bm = match if fill_group.has(tile_map.get_cell(x,     y + 1)) else nomatch
	var lt = match if fill_group.has(tile_map.get_cell(x - 1, y    )) else nomatch
	var rt = match if fill_group.has(tile_map.get_cell(x + 1, y    )) else nomatch
	var br = match if fill_group.has(tile_map.get_cell(x + 1, y + 1)) else nomatch
	var bl = match if fill_group.has(tile_map.get_cell(x - 1, y + 1)) else nomatch
	var tr = match if fill_group.has(tile_map.get_cell(x + 1, y - 1)) else nomatch
	var tl = match if fill_group.has(tile_map.get_cell(x - 1, y - 1)) else nomatch
	
	if (br + rt + bm) >= 1:
		score += 1
	
	if (bl + lt + bm) >= 1:
		score += 2
	
	if (tr + rt + tp) >= 1:
		score += 4
	
	if (tl + lt + tp) >= 1:
		score += 8
	
	return score
