extends Area2D


func _on_body_entered(body:Node2D):
	if body is Vampire:
		body.set_physics_process(false)
		body.visible = false
		$AnimatedSprite2D.play_backwards("default")
		await $AnimatedSprite2D.animation_finished
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(Game.next_level())