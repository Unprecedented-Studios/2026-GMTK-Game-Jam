extends Node2D
class_name Character

signal died

var current_hp:float;
var level:int = 1;
var target:Character;

@export var base_hp: float = 10;
@export var hp_per_level: float = 10;
var max_hp: float:
	get():
		return base_hp + hp_per_level * level;

var is_alive: bool:
	get():
		return current_hp > 0;
		
@export var animation:AnimationPlayer;
@export var attack_rate:float = 1;
@export var attackList:Array[Attack];


@onready var health_bar:StatusBox = get_node("Status/HealthBar");
@onready var buff_display:GridContainer = get_node("Status/BuffsAndDebuffs");
@onready var hitPos:Node2D = get_node("HitAnimationTarget");

@onready var select_box:Line2D = $SelectBox

var mouse_over_me:bool = false

func _ready():
	current_hp = max_hp;
	_update_healthBar();
	
	if self.is_in_group("enemies"):
		select_box.default_color = Color.RED
		select_box.clear_points()
		select_box.add_point(Vector2(-100,-40))
		select_box.add_point(Vector2(100,-40))
		select_box.add_point(Vector2(100,80))
		select_box.add_point(Vector2(-100,80))
	
	if (attack_rate > 0):
		var attack_timer = Timer.new()
		add_child(attack_timer)
		attack_timer.one_shot = false;
		attack_timer.start(attack_rate)
		attack_timer.timeout.connect(_attack);

	
func _update_healthBar():
	health_bar.max_health = max_hp as int;
	health_bar.health = current_hp as int;

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
	if !is_alive:
		return;
	var currDamage = info;
	#loop through buff list for modifiers
	for b:Buff in get_buffs():
		if b.type == Buff.Buff_list.Shield:
			$BlockSound.pitch_scale = randf_range(.95,1.05)
			$BlockSound.play()
			return
		elif b.type == Buff.Buff_list.DefenseDown:
			currDamage *= 1.5
		elif b.type == Buff.Buff_list.DefenseUp:
			currDamage *= .5
	
	$HitSound.pitch_scale = randf_range(.95,1.05)
	$HitSound.play()
	if currDamage.damage > 0:
		
		current_hp -= currDamage.damage
		if animation:
			if (animation.current_animation == "idle"):
				animation.play("hurt");
				animation.seek(0,true)
				animation.queue("idle");
		
		if current_hp <= 0:
			die();
		_update_healthBar();
		
func heal(amount:int) -> void:
	if !is_alive:
		return #return cause you can't heal someone who's dead...
	var currHeal = amount;
	
	#loop through buff list for modifiers
	$HealSound.play()
	$HealParticles.restart()
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
	
	await animation.animation_finished
	died.emit();

func _attack():
	pass;

func attack_hit(_num:int):
	if (target && attackList[_num]):
		attackList[_num].attack(target)

func apply_buff(new_buff:Buff):
	for b:Buff in buff_display.get_children():
		if b.type == new_buff.type:
			b.queue_free()
	if new_buff.type == Buff.Buff_list.HealOverTime:
		new_buff.heal_tick.connect(heal)
	if new_buff.debuff:
		for b:Buff in get_buffs():
			if b.type == Buff.Buff_list.Resist:
				return
	buff_display.add_child(new_buff)
	
func dispell():
	for b:Buff in buff_display.get_children():
		if b.debuff:
			b.queue_free()

func _input(_event: InputEvent) -> void:
	if mouse_over_me and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		select_box.show()

func get_buffs() -> Array[Buff]:
	var buffs:Array[Buff] = []
	for b:Buff in buff_display.get_children():
		buffs.append(b)
	return buffs
		

func _on_area_2d_mouse_entered() -> void:
	mouse_over_me = true

func _on_area_2d_mouse_exited() -> void:
	mouse_over_me = false
