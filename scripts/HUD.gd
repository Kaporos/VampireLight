extends Control


@export var player: Vampire;

@onready var menu = load("res://scenes/menu.tscn");


func _ready():
	$Stats.visible = true
	$GameOver.visible = false
	$MarginContainer.visible = false
	player.stats.dead.connect(dying)
	player.stats.health_changed.connect(health_changed)
	player.bat_time_left.connect(bat_time)
	if !player.can_transform:
		%Bat.value = 0
		%Bat.tint_under = Color("ffffff26")


func bat_time(value):
	%Bat.value = (float(value) / float(player.BAT_DURATION)) * 100
	

func dying():
	$GameOver.visible = true
	$Stats.visible = false
	$MarginContainer.visible = true

	%Restart.grab_focus();
	player.die()

func health_changed(value, _isHit):
	%Health.value = value

func _on_button_pressed():
	player.stats.hit(10)


func _on_restart_pressed():
	#Restarting current level
	Game.index -= 1;
	get_tree().change_scene_to_packed(Game.next_level())


func _on_god_pressed():
	player.stats.health = 1000000
