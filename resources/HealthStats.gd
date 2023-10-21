extends Resource
class_name HealthStats

signal health_changed(value, hit);
signal dead;

@export var health: int = 100: set=_changed;
@export var maxHealth: int = 115;

var justHit = true;
func heal(value):
	justHit = false;
	health += value;


func hit(value):
	justHit = true;
	health -= value;


func _changed(value):
	health_changed.emit(value, justHit)
	health = value
	if health <= 0:
		dead.emit()
