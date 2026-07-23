extends Node2D
class_name Character

@export var max_hp: int = 100;
var current_hp;

@onready var health_bar:StatusBox = get_node("Status/HealthBar");
@onready var buff_display:GridContainer = get_node("Status/BuffsAndDebuffs");

func _ready():
	current_hp = max_hp;
	pass
	
func _update_healthBar():
	health_bar.max_health = max_hp;
	health_bar.health = current_hp;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func take_damage(info:DamageInfo) -> void:
	var currDamage = info;
	#loop through buff list for modifiers
	
	current_hp -= currDamage.damage
	#TODO play damage animation based on type?
	
	if current_hp < 0:
		die();
	_update_healthBar();
	
func heal(amount:int) -> void:
	var currHeal = amount;
	
	#loop through buff list for modifiers
	
	current_hp += currHeal;
	if current_hp > max_hp:
			current_hp = max_hp;
	#TODO play heal animation?
	_update_healthBar();
	

func die() -> void:
	current_hp = 0;
	
	#TODO: death animation?
	
	_update_healthBar();
