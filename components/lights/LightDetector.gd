extends Area2D


@export var debug: bool = false;

signal exposed;
var lights = [];
var lines = [];
var damaged = true;
func _timeout():
	damaged = true

func _ready():
	$Timer.timeout.connect(_timeout)


func _physics_process(_delta):

	#Removing previous frame debug lines
	for line in lines:
		line.queue_free();
	lines.clear()

	#Raycasting for each light
	for light in lights:
		var result = RayCaster.can_raycast(global_position, light.global_position, 0b100)
		if result && damaged:
			damaged = false
			exposed.emit()
			$Timer.wait_time = 0.1
			$Timer.start()
		
		if debug:
			var line = Line2D.new();
			line.add_point(global_position)
			line.add_point(light.global_position)
			line.default_color = Color('ff0000') if result else Color("00ff00")
			get_tree().root.add_child(line);
			lines.append(line)

func _on_light_entered(area:Area2D):
	lights.append(area);


func _on_light_exited(area:Area2D):
	lights.erase(area)
