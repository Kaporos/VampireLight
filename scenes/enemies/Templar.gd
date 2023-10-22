extends Movement
class_name Templar

@export var dmg = 20
@export var jumpheight = 1800;
@export var jumpwidth = 300;
@export var stats: HealthStats;
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target : CharacterBody2D = null
var to_target_vector : Vector2 = Vector2.ZERO

var attacking = false
var attack_ready = false
var jumping = false
var jump_ready = false

func _ready():
	idle_movement.points_list = idle_points_list;
	global_position = idle_movement.points_list[0].global_position
	stats.dead.connect(_on_death)


func agro_move(delta):
	speed = 200
	to_target_vector = target.global_position - global_position
	var direction_to_target = (to_target_vector).normalized()
	velocity.x = (speed * direction_to_target).x
	velocity.y += gravity * delta
	
	if jump_ready:
		jump_ready = false
		jumping = true
		velocity.y = -jumpheight
		velocity.x += (direction_to_target * jumpwidth).x
		
	return velocity

func _process(delta):
	#orient sprite 
	$AnimatedSprite2D.flip_h = velocity.x < 0
	if $AnimatedSprite2D.flip_h :
		$CollisionSlash.scale = Vector2(-1, 1)
	else :
		$CollisionSlash.scale = Vector2(1, 1)
	
	if (jumping && abs(to_target_vector.x) < 70) || (attacking && jumping):
		print("done")
		attacking = true
		if velocity.y != 0:
			$AnimationPlayer.play("falling")
		else:
			$AnimationPlayer.play("Landing")
			await $AnimationPlayer.animation_finished
			attacking = false
			jumping = false
		
		
	
	#Slash attack
	if attack_ready && to_target_vector.length() < 50 && !attacking && !jumping:
		attack_ready = false
		attacking = true
		$Attack.start()
		set_physics_process(false)
		$AnimationPlayer.play("forward_slash")
		await $AnimationPlayer.animation_finished
		set_physics_process(true)
		attacking = false
		
	
	#Animation player
	if !attacking:
		if velocity.length() < 5:
			$AnimatedSprite2D.play("idle")
		else:
			if velocity.y == 0:
				$AnimatedSprite2D.play("run")
				jumping = false
			elif velocity.y < 0:
				$AnimatedSprite2D.play("jump_up")
			else :
				$AnimatedSprite2D.play("jump_down")
			

func _on_death():
	set_process(false)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()


func _on_agro_zone_body_entered(body):
	agro = true
	target = body
	$Jump.start()
	$Attack.start()


func _on_attack_timeout():
	attack_ready = true

func _on_jump_timeout():
	jump_ready = true


func _on_hitbox_forward_slash_body_entered(body):
	body.stats.hit(dmg)


func _on_hitbox_jump_attack_body_entered(body):
	body.stats.hit(dmg * 1.5)
