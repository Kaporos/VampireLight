extends TileMap
class_name LightedTilemap
@export var lightsEnabled: bool = true;
@onready var light_prefab = preload("res://components/lights/SimplePointLight.tscn");
@onready var water_particles = preload("res://scenes/nodes/WaterParticles.tscn");

func _ready():
	for layer in range(get_layers_count()):
		var used_tiles: Array[Vector2i] = get_used_cells(layer);
		for tile in used_tiles:
			var properties = get_cell_tile_data(layer, tile);
			var light_intensity = properties.get_custom_data("light");
			var is_water_particles = properties.get_custom_data("water_particles");
			if light_intensity > 0:
				var coords = to_global(map_to_local(tile));
				var light: Light2D = light_prefab.instantiate();
				light.global_position = coords
				light.energy = 1 + 0.2*light_intensity;
				get_tree().root.add_child(light);
			if is_water_particles:
				var coords = to_global(map_to_local(tile));
				var particles = water_particles.instantiate();
				particles.global_position = coords
				particles.position.y += 30
				get_tree().root.add_child(particles);


