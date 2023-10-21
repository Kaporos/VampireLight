extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var direction = -1
@export var dmg = 20

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#var agro = false
var target = null
var jumping = false
var dead = false

var hp = HealthStats.new()


func _physics_process(delta):
	if(not dead):
		dead = hp.health <= 0
	jumping = not is_on_floor()
	if not is_on_floor():
		velocity.y += gravity * delta
	if ((not $f_hitbox.has_overlapping_bodies()) or is_on_wall()) and is_on_floor(): 
		velocity.y = JUMP_VELOCITY
	if(target != null):
		if(abs(target.position.x - position.x) >= 200):
			direction = (int(target.position.x - position.x > 0) * 2) - 1
		velocity.x = direction * SPEED
		
	else :
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if(jumping and not dead):
		if(direction == 1):
			$AnimatedSprite2D.play("jump_right")
		else:
			$AnimatedSprite2D.play("jump_left")
	elif not dead:
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
	else:
		if(direction == 1):
			$AnimatedSprite2D.play("death_right")
		else:
			$AnimatedSprite2D.play("death_left")

func _on_agro_zone_body_entered(body):
	target = body
	

func _on_agro_zone_body_exited(body):
	target = null
	



func _on_animated_sprite_2d_animation_looped():
	if(dead):
		queue_free()


func _on_area_2d_body_entered(body):
	body.stats.hit(dmg)
