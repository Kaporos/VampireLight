@tool
extends Node2D
class_name GameAutoload

@export var levels: Array[PackedScene] = [];
@export var menu = load("res://scenes/menu.tscn")

@export var index = -1;

var deaths = 0;
var elapsed = 0;
var timestart = 0;

func _process(delta):
	if timestart:
		elapsed = Time.get_unix_time_from_system() - timestart

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
	print("Index was ", index," going to", index+1)
	index += 1
	if index == len(levels):
		print("overflow -> returning menu :D")
		index = -1
		return menu
	timestart = Time.get_unix_time_from_system()
	return levels[index]
