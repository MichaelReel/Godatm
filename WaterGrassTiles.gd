extends TileMap

export var gridSize = Vector2()

func _ready():
	
	var perlin = load("res://PerlinRef.gd").new(64, 64, 10)
	# Called every time the node is added to the scene.
	# Initialization here
	var tilemap = self
	var tileset = tilemap.get_tileset()
	var water = tileset.find_tile_by_name("WaterGrass_00")
	var grass = tileset.find_tile_by_name("Grass_01")
	
	var grid_start_x = 0
	var grid_start_y = 0
	var grid_end_x = int(gridSize.x)
	var grid_end_y = int(gridSize.y)
	
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			if perlin.getHash(x, y) >= 0.05:
				tilemap.set_cell(x, y, water)
			else:
				tilemap.set_cell(x, y, grass)
