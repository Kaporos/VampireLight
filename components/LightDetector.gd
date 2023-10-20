extends Area2D


@export var debug: bool = false;

signal exposed;
var lights = [];
var lines = [];

func _physics_process(_delta):

	#Removing previous frame debug lines
	for line in lines:
		line.queue_free();
	lines.clear()

	#Raycasting for each light
	for light in lights:
		if debug:
			var line = Line2D.new();
			line.add_point(global_position)
			line.add_point(light.global_position)
			get_tree().root.add_child(line);
			lines.append(line)
		if RayCaster.can_raycast(global_position, light.global_position):
			exposed.emit()

func _on_light_entered(area:Area2D):
	lights.append(area);


func _on_light_exited(area:Area2D):
	lights.erase(area)
