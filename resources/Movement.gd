extends CharacterBody2D
class_name Movement

@export var speed: int = 300;
@export var gravity_affected : bool = true;
@export var agro : bool = false;
@export var idle_points_list: Array[Node2D] = [];
@export var idle_movement : IdleMovement;



#Index point de commencement
var index = 0


func _ready():
	idle_movement.points_list = idle_points_list;
	global_position = idle_movement.points_list[0].global_position

func agro_move(delta):
	print("called")
	push_warning("Not Impemented Yet Called")
	
func _physics_process(delta):
	if (agro):
		velocity = agro_move(delta)
	else : 
		velocity = idle_movement.move(delta, global_position, gravity_affected, speed)
	move_and_slide()
