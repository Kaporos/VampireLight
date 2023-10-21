extends CharacterBody2D 


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var direction = -1
@export var cooldown = 3000
@export var att_mode = 1
@export var power = 50000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var garlic = preload("res://scenes/enemies/garlic.tscn");
var target = null
var count_time = 0
var dead = false
var i = att_mode * int(att_mode != 2)
var firing = false
var hp = HealthStats.new()

func _physics_process(delta):
	if not is_on_floor() :
		velocity.y += gravity * delta
		move_and_slide()
	if(not dead):
		dead = hp.health <= 0
	if target and not dead:
		direction = (int(target.position.x - position.x > 0) * 2) - 1

		if(not $AnimatedSprite2D.is_playing()):
			if(firing):
				var some_garlic = garlic.instantiate();
				some_garlic.position = Vector2(direction * 35,0)
				if(i):
					if(direction == 1):
						some_garlic.apply_force(Vector2i(power,0))
					else :
						some_garlic.apply_force(Vector2i(-1 * power,0))
				else:
					if(direction == 1):
						some_garlic.apply_force(Vector2i(power * 0.707,-1 * power * 0.707))
					else :
						some_garlic.apply_force(Vector2i(-1 * power * 0.707,-1 * power * 0.707))
				add_child(some_garlic)
				firing = false
			if(direction == 1):
				$AnimatedSprite2D.play("idle_right")
			else :
				$AnimatedSprite2D.play("idle_left")
		if(Time.get_ticks_msec() - count_time >= cooldown):
			firing = true
			if(direction == 1):
				$AnimatedSprite2D.play("shooting_right")
			else :
				$AnimatedSprite2D.play("shooting_left")
			count_time = Time.get_ticks_msec()
			
			if(att_mode == 2):
				i = not i
			
	elif not dead:
		if(direction == 1):
			$AnimatedSprite2D.play("idle_right")
		else :
			$AnimatedSprite2D.play("idle_left")
	else:
		if(direction == 1):
			$AnimatedSprite2D.play("death_right")
		else :
			$AnimatedSprite2D.play("death_left")

func _on_area_2d_body_entered(body):
	count_time = Time.get_ticks_msec()
	target = body
	

func _on_area_2d_body_exited(body):
	target = null
	
	


func _on_animated_sprite_2d_animation_looped():
	if(firing):
		$AnimatedSprite2D.stop()
	if(dead):
		queue_free()





func _on_hitbox_area_entered(area):
	print("bobo")
	hp.hit(69)
