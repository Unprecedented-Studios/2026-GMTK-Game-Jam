extends Node2D
class_name Character

@export var max_hp: int = 100;
@export var animation:AnimationPlayer;
var current_hp;

@onready var health_bar:StatusBox = get_node("Status/HealthBar");
@onready var buff_display:GridContainer = get_node("Status/BuffsAndDebuffs");

@onready var select_box:Line2D = $SelectBox

var mouse_over_me:bool = false

func _ready():
	current_hp = max_hp;
	if self.is_in_group("enemies"):
		select_box.default_color = Color.RED
		select_box.clear_points()
		select_box.add_point(Vector2(-100,-40))
		select_box.add_point(Vector2(100,-40))
		select_box.add_point(Vector2(100,80))
		select_box.add_point(Vector2(-100,80))

	
func _update_healthBar():
	health_bar.max_health = max_hp;
	health_bar.health = current_hp;

var selected:bool = false:
	get():
		return select_box.visible
	set(value):
		if value:
			select_box.show()
		else: 
			select_box.hide()
const SELECT_FLASH_SPEED:float = .01
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	select_box.modulate.a = .8 + (sin(Time.get_ticks_msec()*SELECT_FLASH_SPEED)*.2)
	
func take_damage(info:DamageInfo) -> void:
	if current_hp == 0:
				return;
	var currDamage = info;
	#loop through buff list for modifiers
	
	if currDamage.damage > 0:
		
		current_hp -= currDamage.damage
		if animation:
			animation.play("hurt");
			animation.seek(0,true)
			animation.queue("idle");
		
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
	
	animation.play("die")
	_update_healthBar();
	remove_from_group("allies");
	remove_from_group("enemies");

func attack_hit(_num:int):
	pass;

func apply_buff(new_buff:Buff):
	for b:Buff in buff_display.get_children():
		if b.type == new_buff.type:
			b.queue_free()
	buff_display.add_child(new_buff)
	
func dispell():
	for b:Buff in buff_display.get_children():
		if b.debuff:
			b.queue_free()

func _input(event: InputEvent) -> void:
	if mouse_over_me and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		select_box.show()



func _on_area_2d_mouse_entered() -> void:
	mouse_over_me = true

func _on_area_2d_mouse_exited() -> void:
	mouse_over_me = false
