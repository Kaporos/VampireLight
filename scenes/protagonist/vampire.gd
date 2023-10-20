extends Node2D

# @onready var humanoid = load("res://scenes/protagonist/humanoid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var humanoid = load("res://scenes/protagonist/humanoid.tscn")
	var first_vamp = humanoid.instantiate()
	add_child(first_vamp)
	# first_vamp.transform[2] = Vector2(600, 600)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
