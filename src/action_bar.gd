extends HBoxContainer
class_name ActionBar

# Called when the node enters the scene tree for the first time.
var action_preload = preload("res://scenes/action_button.tscn")

func _ready() -> void:
	var basic_attack:Action_Button = action_preload.instantiate()
	basic_attack.action_type = Action_Button.actions_list.BasicAttack
	add_action(basic_attack)
	var small_heal:Action_Button = action_preload.instantiate()
	small_heal.action_type = Action_Button.actions_list.SmallHeal
	add_action(small_heal)
	

func reset():
	for a:Action_Button in get_children():
		if a.action_type != Action_Button.actions_list.BasicAttack and a.action_type != Action_Button.actions_list.SmallHeal:
			a.queue_free()
		else:
			a.set_upgrade_level(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_actions() -> Array[Action_Button]:
	var actions:Array[Action_Button] = []
	for c:Action_Button in get_children():
		actions.append(c)
	return actions
	
func get_action(type: Action_Button.actions_list) -> Action_Button:
	for c:Action_Button in get_children():
		if c.action_type == type:
			return c
	return null

func get_action_types() -> Array[Action_Button.actions_list]:
	var actions:Array[Action_Button.actions_list] = []
	for c:Action_Button in get_children():
		actions.append(c.action_type)
	return actions

var keys:Array[Dictionary] =\
[
	{"key":"Q","key_code":KEY_Q},
	{"key":"W","key_code":KEY_W},
	{"key":"E","key_code":KEY_E},
	{"key":"R","key_code":KEY_R},
	{"key":"A","key_code":KEY_A},
	{"key":"S","key_code":KEY_S},
	{"key":"D","key_code":KEY_D},
	{"key":"F","key_code":KEY_F},
	
]

func add_action(new_action:Action_Button):
	add_child(new_action)
	var child_num = get_child_count()-1
	new_action.set_key(keys[child_num]["key"],keys[child_num]["key_code"])
	new_action.set_icon()
