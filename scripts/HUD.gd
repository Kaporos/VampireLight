extends Control


@export var maxHealth = 100;
var health = maxHealth: set = _setted_health;

func _ready():
	reset();

func reset():
	health = maxHealth

func _setted_health(value):
	$Health.value = health;
	health = value

func _on_button_pressed():
	health -= 5
