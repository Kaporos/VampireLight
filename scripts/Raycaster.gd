extends Node2D
class_name ray

# Called when the node enters the scene tree for the first time.
func can_raycast(pos1, pos2, collision_mask) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(pos1, pos2, collision_mask)
	var result = space_state.intersect_ray(query);
	return !result;
	
