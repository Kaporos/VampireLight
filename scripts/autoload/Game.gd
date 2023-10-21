@tool
extends Node2D
class_name GameAutoload

@export var levels: Array[PackedScene] = [];
@export var menu = load("res://scenes/menu.tscn")

var index = -1;

func _ready():
	if len(levels) == 0:
		push_error("You have to specify at least one level in res://scenes/Game.tscn")
		print("IMPORTANT: You have to specify at least one level in res://scenes/Game.tscn")
		get_tree().quit()

func _get_configuration_warnings():
	var errors = []
	if len(levels) == 0:
		errors.append("You have to specify at least one level")
	return errors

func next_level():
	index += 1
	if index == len(levels):
		index = -1
		return menu
	return levels[index]
