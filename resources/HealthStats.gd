extends Resource
class_name HealthStats

signal health_changed(value);

@export var health: int = 100: set=_changed;
@export var maxHealth: int = 115;

func heal(value):
	health += value;

func hit(value):
	health -= value;

func _changed(value):
	health_changed.emit(value)
	health = value
