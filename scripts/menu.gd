extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	%Start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_packed(Game.next_level());


func _on_leave_pressed():
	get_tree().quit()
