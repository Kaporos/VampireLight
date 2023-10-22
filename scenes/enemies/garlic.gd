extends RigidBody2D
@export var lifetime = 10
@export var dmg = 25

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()
	

func _on_timer_timeout():
	queue_free()




func _on_body_entered(body):
	if body is Vampire:
		body.stats.hit(10)
