extends AnimatedSprite2D


func set_playing():
	play("default")
	await animation_finished
	queue_free()

func _on_area_2d_body_entered(body:Node2D):
	$CinematicPlayer.play("cinematic")
	body.stop_physics();
	await $CinematicPlayer.animation_finished
	body.set_physics_process(true);
