extends Resource
class_name HealthStats

signal health_changed(value, hit);
signal dead;

var dead_sent = false;

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
	health_changed.emit(value, justHit)
	health = value
	if health <= 0 && !dead_sent:
		dead.emit()
		dead_sent = true
