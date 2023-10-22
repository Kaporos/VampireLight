extends Area2D


func _on_body_entered(body:Node2D):
	if body is Vampire:
		body.set_physics_process(false)
		body.visible = false
	$AnimationPlayer.play("close")


func coffin_anim():
	$AnimatedSprite2D.play_backwards("default")

func tp_player():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(Game.next_level())