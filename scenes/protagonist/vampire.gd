extends CharacterBody2D
class_name Vampire
@export var stats: HealthStats;

# @onready var humanoid = load("res://scenes/protagonist/humanoid.tscn")

var is_bat = false;

@export var BAT_SPEED = 1000
@export var HUMANOID_SPEED = 100

const SPEED = 300.0
const JUMP_VELOCITY = -750.0

var collision_offset = false
var orientation_was_right = true
var is_tranforming = false
var elevate_bat = false
var is_attacking = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var dead=false;
# Called when the node enters the scene tree for the first time.
func _ready():
	stats.health_changed.connect(_show_hit_anim)

func _show_hit_anim(_v, isHitted):
	if !isHitted:
		return
	$HitAnimationPlayer.play("hit")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if dead:
		return;

	if elevate_bat:
		transform[2][1] -= BAT_SPEED*delta/8
	if is_tranforming:
		return
	var input_vector = get_input()
	if is_bat:
		move_bat(input_vector)
		if not is_attacking:
			animate_bat(input_vector)
	else:
		move_humanoid(delta, input_vector)
		if not is_attacking:
			animate_humanoid(input_vector)

	check_for_transform()
		
func move_bat(input_vector):
	$HumanoidCollision.disabled = true
	$BatCollision.disabled = false
	var direction_horizontal = input_vector.x
	var direction_vertical = input_vector.y
	velocity.x = direction_horizontal
	velocity.y = direction_vertical
	velocity = velocity.normalized() * BAT_SPEED
	move_and_slide()

func move_humanoid(delta, input_vector):
	$HumanoidCollision.disabled = false
	$BatCollision.disabled = true
	# Add the gravity.
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
			await get_tree().create_timer(0.8).timeout
			is_attacking = false
			return
		else:
			$BatAnimation.play("attack_left")
			await get_tree().create_timer(0.8).timeout
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
		if orientation_was_right:
			is_attacking = true
			$HumanoidAnimation.play("attack_right")
			await get_tree().create_timer(0.5).timeout
			is_attacking = false
			return
		else:
			is_attacking = true
			$HumanoidAnimation.play("attack_left")
			await get_tree().create_timer(0.5).timeout
			is_attacking = false
			return

	if (input_vector[0] == 0 and input_vector[1] == 0):
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

	var transform_command = Input.is_action_pressed("bat_transform")
	if transform_command:

		if is_bat:
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
	dead = true
	visible = false



func get_usefull_vector():
	var input_vector = get_input()
	var x_comp = input_vector[1] - input_vector[0]
	var y_comp = input_vector[3] - input_vector[2]
	return Vector2(x_comp, y_comp)
