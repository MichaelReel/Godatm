extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var gridSize = Vector2();

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var tilemap = self;
	var tileset = tilemap.get_tileset();
	var water = tileset.find_tile_by_name("WaterGrass_00");
	
	var grid_start_x = 0;
	var grid_start_y = 0;
	var grid_end_x = int(gridSize.x);
	var grid_end_y = int(gridSize.y);
	
	for y in range(grid_start_y, grid_end_y):
		for x in range(grid_start_x, grid_end_x):
			var cell = tilemap.set_cell(x, y, water);
