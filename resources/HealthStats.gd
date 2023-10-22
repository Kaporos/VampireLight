extends Resource
class_name HealthStats

signal health_changed(value, hit);
signal dead;

var frozen = false;

@export var health: int = 100: set=_changed;
@export var maxHealth: int = 115;

var justHit = true;
func heal(value):
	justHit = false;
	health += value;


func hit(value):
	justHit = true;
	health -= value;

func set_health_without_hit(value):
	justHit = false;
	health = value


func _changed(value):
	if frozen:
		return
	health_changed.emit(value, justHit)
	health = value
	if health <= 0:
		dead.emit()
