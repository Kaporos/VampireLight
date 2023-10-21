extends Control


@export var player: Vampire;

@onready var menu = load("res://scenes/menu.tscn");


func _ready():
	$Stats.visible = true
	$GameOver.visible = false
	player.stats.health_changed.connect(health_changed)
	
	$GameOver.visible = true
	$Stats.visible = false
	player.die()

func health_changed(value, _hit):
	%Health.value = value
	if value <= 0:
		$GameOver.visible = true
		$Stats.visible = false
		player.die()


func _on_button_pressed():
	player.stats.hit(10)


func _on_restart_pressed():
	call_deferred("go_menu")
	queue_free()
func go_menu():
	get_tree().change_scene_to_packed(menu);
