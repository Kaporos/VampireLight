extends AudioStreamPlayer

@export var is_playing = false

func _on_finished():
	is_playing = false
