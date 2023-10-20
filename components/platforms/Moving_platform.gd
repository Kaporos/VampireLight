extends CharacterBody2D


@export var point_list: Array[Node2D] = [];
@export var speed: int = 300;
@export var should_rotate : bool = false;
@export var rotate_speed : int = 0; #rad/s
@export var started : bool = true;
@export var retour : bool = true;

var index = 0
var stop  = false
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = point_list[0].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(started and (not stop)):
		var destination = point_list[(index + 1) % point_list.size()]
		var direction =  destination.global_position - global_position;
		velocity = direction.normalized() * speed;
		if(direction.length() < 5):
			index = index + 1
			print(index)
			if(index == point_list.size()):
				index = 0
			if (index == point_list.size() - 1) && !retour:
				stop = true 
			global_position = point_list[index].global_position;

		move_and_collide(velocity * delta);
		if(should_rotate):
			rotation = (destination.global_position.y - global_position.y)/(destination.global_position.x - global_position.x)
