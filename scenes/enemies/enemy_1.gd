extends Movement
class_name Enemy1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var stats: HealthStats;
@export var JUMP_VELOCITY = -400.0
@export var direction = -1
@export var dmg = 20

var target = null
var jumping = false

func _ready():
	idle_movement.points_list = idle_points_list;
	global_position = idle_movement.points_list[0].global_position
	stats.dead.connect(_on_death)
	

func agro_move(delta):
	jumping = not is_on_floor()
	if not is_on_floor():
		velocity.y += gravity * delta
	if ((not $f_hitbox.has_overlapping_bodies()) or is_on_wall()) and is_on_floor(): 
		velocity.y = JUMP_VELOCITY
	if(target != null):
		if(abs(target.position.x - position.x) >= 200):
			direction = (int(target.position.x - position.x > 0) * 2) - 1
		velocity.x = direction * speed
	else :
		velocity.x = move_toward(velocity.x, 0, speed)
	return velocity

func _process(delta):
	if(jumping):
		if(direction == 1):
			$AnimatedSprite2D.play("jump_right")
		else:
			$AnimatedSprite2D.play("jump_left")
	if(target):
		if(direction == 1):
			$AnimatedSprite2D.play("sprint_right")
		else:
			$AnimatedSprite2D.play("sprint_left")
	else:
		if(direction == 1):
			$AnimatedSprite2D.play("idle_right")
		else:
			$AnimatedSprite2D.play("idle_left")
	

func _on_agro_zone_body_entered(body):
	target = body
	agro = true
	
func _on_death():
	set_process(false)
	if direction == 1:
		$AnimatedSprite2D.play("death_right")
	else:
		$AnimatedSprite2D.play("death_left")
	await $AnimatedSprite2D.animation_finished
	queue_free()
	

func _on_agro_zone_body_exited(body):
	target = null

func _on_hitbox_body_entered(body):
	body.stats.hit(dmg)
	
