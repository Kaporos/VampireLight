extends TileMap
class_name LightedTilemap
@export var lightsEnabled: bool = true;
@onready var light_prefab = preload("res://components/lights/SimplePointLight.tscn");

func _ready():
	for layer in range(get_layers_count()):
		var used_tiles: Array[Vector2i] = get_used_cells(layer);
		for tile in used_tiles:
			var properties = get_cell_tile_data(layer, tile);
			var light_intensity = properties.get_custom_data("light");
			if light_intensity > 0:
				var coords = to_global(map_to_local(tile));
				var light: Light2D = light_prefab.instantiate();
				light.global_position = coords
				light.energy = 1 + 0.2*light_intensity;
				get_tree().root.add_child(light);


