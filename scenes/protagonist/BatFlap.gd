extends AudioStreamPlayer

@export var is_playing = false

func _on_finished():
	await get_tree().create_timer(0.27).timeout
	is_playing = false
