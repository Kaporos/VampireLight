extends Control


@export var player: Vampire;

@onready var menu = load("res://scenes/menu.tscn");


func _ready():
	$Stats.visible = true
	$GameOver.visible = false
	player.stats.dead.connect(dying)
	player.stats.health_changed.connect(health_changed)

func dying():
	print("done")
	$GameOver.visible = true
	$Stats.visible = false
	player.die()

func health_changed(value, _isHit):
	%Health.value = value

func _on_button_pressed():
	player.stats.hit(10)


func _on_restart_pressed():
	call_deferred("go_menu")
	queue_free()
func go_menu():
	get_tree().change_scene_to_packed(menu);
