extends Node2D

var enemies1 = preload("res://scenes/enemies/enemy_1.tscn")
var enemies2 = preload("res://scenes/enemies/enemy_2.tscn")
var enemies3 = preload("res://scenes/enemies/enemy_3.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy3 = enemies3.instantiate()
	enemy3.position = Vector2(610,170)
	add_child(enemy3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
