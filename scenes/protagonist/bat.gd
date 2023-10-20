extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _collision_shape = $CollisionShape2D

@onready var humanoid = load("res://scenes/protagonist/humanoid.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_tranforming = false
var collision_offset = false
var orientation_was_right = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if is_tranforming:
		return

	var transform_command = Input.is_action_pressed("bat_transform")

	if transform_command:
		is_tranforming = true
		if orientation_was_right:
			_animated_sprite.play("bat_transform_right")
			await get_tree().create_timer(0.4).timeout
			is_tranforming = false
			var humanoid_instance = humanoid.instantiate()
			humanoid_instance.transform[2] = transform[2]
			get_parent().add_child(humanoid_instance)
			queue_free()
		else:
			_animated_sprite.play("bat_transform_left")
			await get_tree().create_timer(0.4).timeout
			is_tranforming = false
			queue_free()
		return

	controll_animation(get_input())


	# Add the gravity.
	if not is_on_floor():
		pass
		# velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_horizontal = Input.get_axis("ui_left", "ui_right")
	var direction_vertical = Input.get_axis("ui_up", "ui_down")
	if direction_horizontal:
		velocity.x = direction_horizontal * SPEED
	else:
		velocity.x = 0
	if direction_vertical:
		velocity.y = direction_vertical * SPEED
	else:
		velocity.y = 0

	move_and_slide()

func get_input():
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
func controll_animation(input_vector):
	if (input_vector[0] == 0 and input_vector[1] == 0):
		if orientation_was_right:
			_animated_sprite.play("idle_right")
			return
		_animated_sprite.play("idle_left")
		return
	if input_vector[0] > 0:
		_animated_sprite.play("idle_right")
		if collision_offset:
			_collision_shape.position.x -= 5
			collision_offset = false
		if !orientation_was_right:
			orientation_was_right = true
		return

	if input_vector[0] < 0:
		_animated_sprite.play("idle_left")
		if !collision_offset:
			_collision_shape.position.x += 5
			collision_offset = true
		if orientation_was_right:
			orientation_was_right = false
