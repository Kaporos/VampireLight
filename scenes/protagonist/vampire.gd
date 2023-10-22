extends CharacterBody2D
class_name Vampire
@export var stats: HealthStats;

# @onready var humanoid = load("res://scenes/protagonist/humanoid.tscn")

var is_bat = false;

@export var can_transform : bool = true
@export var BAT_SPEED = 1000
@export var DAMAGE : int = 1000
@export var HUMANOID_SPEED = 100
@export var BAT_DURATION = 5000

const SPEED = 300.0
const JUMP_VELOCITY = -750.0

var collision_offset = false
var orientation_was_right = true
var is_tranforming = false
var elevate_bat = false
var is_attacking = false
var body_in_lava = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var old_vampire_life;	
var allow_up = false;

var time_count = 0 #compte le temps depuis la transformation

signal bat_time_left(value);


# Called when the node enters the scene tree for the first time.
func _ready():
	stats.health_changed.connect(_show_hit_anim)
	stats.health = stats.maxHealth
	stats.dead_sent = false

func _show_hit_anim(_v, isHitted):
	if !isHitted:
		return
	$HitAnimationPlayer.play("hit")
func check_collisions_physic_layer_and_light():
	var collision2dbat = $TilesDetector.get_node("BatCollision")
	var collision2dhooman = $TilesDetector.get_node("HumanoidCollision")
	var collision2dbatlight = $LightDetector.get_node("BatCollision")
	var collision2dhoomanlight = $LightDetector.get_node("HumanoidCollision")
	if is_bat:
		collision2dbat.disabled = false
		collision2dhooman.disabled = true
		collision2dbatlight.disabled = false
		collision2dhoomanlight.disabled = true
	else:
		collision2dbat.disabled = true
		collision2dhooman.disabled = false
		collision2dbatlight.disabled = true
		collision2dhoomanlight.disabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if body_in_lava:
		stats.hit(200)
	if elevate_bat:
		transform[2][1] -= BAT_SPEED*delta/8
	if is_tranforming:
		return
	check_collisions_physic_layer_and_light()
	var input_vector = get_input()
	if is_bat:
		if !$BatFlap.is_playing:
			$BatFlap.play()
			$BatFlap.is_playing = true
		move_bat(input_vector)
		if not is_attacking:
			animate_bat(input_vector)

		
	else:
		move_humanoid(delta, input_vector)
		if not is_attacking:
			animate_humanoid(input_vector)

	check_for_transform()

func stop_physics():
	set_physics_process(false);
	$HumanoidAnimation.play("idle_right")

func move_bat(input_vector):
	if(visible):
		$HumanoidCollision.disabled = true
		$BatCollision.disabled = false
		var direction_horizontal = input_vector.x
		var direction_vertical = input_vector.y
		velocity.x = direction_horizontal
		velocity.y = direction_vertical
		velocity = velocity.normalized() * BAT_SPEED
		move_and_slide()

func move_humanoid(delta, input_vector):
	if(visible):
		$HumanoidCollision.disabled = false
		$BatCollision.disabled = true
		# Add the gravity.
		if allow_up:
			var directiony = input_vector.y
			if directiony:
				velocity.y = directiony*SPEED
			else:
				velocity.y = move_toward(velocity.y, 0, SPEED)
		else :
			if not is_on_floor():
				velocity.y += gravity * delta

			# Handle Jump.
			if Input.is_action_just_pressed("w_pressed") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = input_vector.x
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()

func animate_bat(input_vector):
	$HumanoidAnimation.visible = false
	$BatAnimation.visible = true

	if is_attacking:
		if orientation_was_right:
			
			$BatAnimation.play("attack_right")
			$HitAreaRight2/HitAreaRight.disabled = false
			await get_tree().create_timer(0.8).timeout
			$HitAreaRight2/HitAreaRight.disabled = true			
			is_attacking = false
			return
		else:
			$BatAnimation.play("attack_left")
			$HitAreaLeftt2/HitAreaLeft.disabled = false
			await get_tree().create_timer(0.8).timeout
			$HitAreaLeftt2/HitAreaLeft.disabled = true
			is_attacking = false
			return

	if (input_vector[0] == 0 and input_vector[1] == 0):
		if orientation_was_right:
			$BatAnimation.play("idle_right")
			return
		$BatAnimation.play("idle_left")
		return
	if input_vector[0] > 0:
		$BatAnimation.play("idle_right")
		if !orientation_was_right:
			orientation_was_right = true
		return

	if input_vector[0] < 0:
		$BatAnimation.play("idle_left")
		if orientation_was_right:
			orientation_was_right = false

func animate_humanoid(input_vector):
	$HumanoidAnimation.visible = true
	$BatAnimation.visible = false

	if Input.is_action_just_pressed("ui_accept"):
		$SwordSlash.play()

		if $WalkingSound.is_playing:
			$WalkingSound.stop()
			$WalkingSound.is_playing = false
		if orientation_was_right:
			is_attacking = true
			$HumanoidAnimation.play("attack_right")
			$HitAreaRight2/HitAreaRight.disabled = false
			await get_tree().create_timer(0.5).timeout
			$HitAreaRight2/HitAreaRight.disabled = true
			is_attacking = false
			return
		else:
			is_attacking = true
			$HumanoidAnimation.play("attack_left")
			$HitAreaLeftt2/HitAreaLeft.disabled = false
			await get_tree().create_timer(0.5).timeout
			$HitAreaLeftt2/HitAreaLeft.disabled = true
			is_attacking = false
			return

	if !is_on_floor():
		if $WalkingSound.is_playing:
			$WalkingSound.stop()
			$WalkingSound.is_playing = false

	# if (input_vector[0] == 0 and input_vector[1] == 0):
	if (input_vector[0] == 0):
		if $WalkingSound.is_playing:
			$WalkingSound.stop()
			$WalkingSound.is_playing = false
		if orientation_was_right:
			if collision_offset:
				$HumanoidAnimation.position.x += 20
				collision_offset = false
			$HumanoidAnimation.play("idle_right")
			return
		if !collision_offset:
			$HumanoidAnimation.position.x -= 20
			collision_offset = true
		$HumanoidAnimation.play("idle_left")
		return

	if !$WalkingSound.is_playing and is_on_floor():
		$WalkingSound.play()
		$WalkingSound.is_playing = true

	if input_vector[0] > 0:
		$HumanoidAnimation.play("walking_right")
		if collision_offset:
			$HumanoidAnimation.position.x += 20
			collision_offset = false
		if !orientation_was_right:
			orientation_was_right = true
		return
	else:
		$HumanoidAnimation.play("walking_left")
		if !collision_offset:
			$HumanoidAnimation.position.x -= 20
			collision_offset = true
		if orientation_was_right:
			orientation_was_right = false
		return

func check_for_transform():
	if !can_transform:
		return
	var transform_command = Input.is_action_pressed("bat_transform") or (is_bat and (Time.get_ticks_msec() - time_count >= BAT_DURATION))
	if is_bat:
		bat_time_left.emit(BAT_DURATION - (Time.get_ticks_msec() - time_count))
	else:
		bat_time_left.emit(BAT_DURATION)
	$Transform.play()
	if transform_command:
		
		if $WalkingSound.is_playing:
			$WalkingSound.stop()
			$WalkingSound.is_playing = false

		if is_bat:
			stats.set_health_without_hit(old_vampire_life if old_vampire_life else stats.maxHealth)
			is_tranforming = true
			elevate_bat = true
			if orientation_was_right:
				await get_tree().create_timer(0.3).timeout
				elevate_bat = false
				$BatAnimation.play("bat_transform_right")
				await $BatAnimation.animation_finished

				is_tranforming = false
				is_bat = false
			else:
				await get_tree().create_timer(0.3).timeout
				elevate_bat = false
				$BatAnimation.play("bat_transform_left")
				await $BatAnimation.animation_finished
				is_tranforming = false
				is_bat = false
			return
		elif is_on_floor():
			time_count = Time.get_ticks_msec()
			old_vampire_life = stats.health
			stats.set_health_without_hit(2)

			is_tranforming = true
			if orientation_was_right:
				$HumanoidAnimation.play("bat_transform_right")
				await $HumanoidAnimation.animation_finished
				is_tranforming = false
				is_bat = true
			else:
				$HumanoidAnimation.play("bat_transform_left")
				await $HumanoidAnimation.animation_finished
				is_tranforming = false
				is_bat = true
			return

func get_input():
	return Input.get_vector("a_pressed", "d_pressed", "w_pressed", "s_pressed")


func die():
	visible = false
	$DeathSound.play()
	$DeathSound.is_playing = true



func get_usefull_vector():
	var input_vector = get_input()
	var x_comp = input_vector[1] - input_vector[0]
	var y_comp = input_vector[3] - input_vector[2]
	return Vector2(x_comp, y_comp)

func _on_tiles_detector_body_entered(_body: Node2D):
	if not body_in_lava:
		body_in_lava = true

func _on_tiles_detector_body_exited(_body: Node2D):
	body_in_lava = false

func _on_light_detector_exposed():
	stats.hit(8)


func _on_ladder_detector_body_exited(_body:Node2D):
	allow_up = false


func _on_ladder_detector_body_entered(_body:Node2D):
	allow_up = true
	print("setted allow-up")

func _on_hit_area_right_2_body_entered(body):
	print("hit enemy right")
	body.stats.hit(DAMAGE)

func _on_hit_area_leftt_2_body_entered(body):
	print("hit enemy left")
	body.stats.hit(DAMAGE)
