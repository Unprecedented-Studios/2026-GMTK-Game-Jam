extends Node2D
class_name Character

@export var max_hp: int = 100;
var current_hp;

@onready var health_bar:StatusBox = get_node("Status/HealthBar");
@onready var buff_display:GridContainer = get_node("Status/BuffsAndDebuffs");
@onready var sprite:AnimatedSprite2D = get_node("Character");
@onready var animation:AnimationPlayer = get_node("AnimationPlayer");

func _ready():
	current_hp = max_hp;
	sprite.play("idle")
	sprite.animation_finished.connect(_on_character_animation_finished);
	pass
	
func _update_healthBar():
	health_bar.max_health = max_hp;
	health_bar.health = current_hp;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func take_damage(info:DamageInfo) -> void:
	if current_hp == 0:
				return;
	var currDamage = info;
	#loop through buff list for modifiers
	
	if currDamage.damage > 0:
		
		sprite.play("hurt")
		sprite.frame=0
		current_hp -= currDamage.damage
		
		if current_hp <= 0:
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
	sprite.play("die")
	
	_update_healthBar();


func _on_character_animation_finished():
	if current_hp == 0:
		queue_free();
	else:
		sprite.play("idle")

	pass # Replace with function body.

func attack_hit(num:int):
	pass;
