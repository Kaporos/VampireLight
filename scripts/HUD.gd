extends Control


@export var player: Vampire;

var menu = preload("res://scenes/menu.tscn");

func _ready():
	$Stats.visible = true
	$GameOver.visible = false
	player.stats.dead.connect(dying)

func dying():
	print("done")
	$GameOver.visible = true
	$Stats.visible = false
	player.die()


func _on_button_pressed():
	player.stats.hit(10)


func _on_restart_pressed():
	get_tree().change_scene_to_packed(menu);
