extends Control


@export var player: Vampire;


func _ready():
	player.stats.health_changed.connect(health_changed)

func health_changed(value, _hit):
	$Health.value = value


func _on_button_pressed():
	player.stats.hit(10)
