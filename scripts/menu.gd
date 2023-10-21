extends Control

@export var start_scene: PackedScene = preload("res://levels/Level1.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	%Start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_packed(start_scene);


func _on_leave_pressed():
	get_tree().quit()
