extends Resource
class_name IdleMovement

#Chemin
var points_list: Array[Node2D];

@export var started : bool = true;
#Fait une boucle
@export var retour : bool = true;
@export var tp_distance : int = 5;
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var index = 0
var stop  = false


func move(delta, global_position, gravity_affected, speed):
	var velocity = Vector2.ZERO
	if(started and (not stop)):
		var destination = points_list[(index + 1) % points_list.size()]
		var direction =  destination.global_position - global_position;
		if (gravity_affected) :
			velocity = direction.normalized() * speed;
			velocity.y += gravity * delta;
		else :
			velocity = direction.normalized() * speed;
		if(direction.length() < tp_distance):
			index = index + 1
			if(index == points_list.size() && retour):
				index = 0
			else :
				stop = false
			global_position = points_list[index].global_position;
		return velocity
	return Vector2.ZERO
