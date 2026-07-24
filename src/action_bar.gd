extends HBoxContainer
class_name ActionBar

# Called when the node enters the scene tree for the first time.
var action_preload = preload("res://scenes/action_button.tscn")

func _ready() -> void:
	var basic_attack:Action = action_preload.instantiate()
	basic_attack.action_type = Action.actions_list.BasicAttack
	add_action(basic_attack)
	var small_heal:Action = action_preload.instantiate()
	small_heal.action_type = Action.actions_list.SmallHeal
	add_action(small_heal)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_actions() -> Array[Action]:
	var actions:Array[Action] = []
	for c:Action in get_children():
		actions.append(c)
	return actions

func get_action_types() -> Array[Action.actions_list]:
	var actions:Array[Action.actions_list] = []
	for c:Action in get_children():
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

func add_action(new_action:Action):
	add_child(new_action)
	var child_num = get_child_count()-1
	new_action.set_key(keys[child_num]["key"],keys[child_num]["key_code"])
	new_action.set_icon()
