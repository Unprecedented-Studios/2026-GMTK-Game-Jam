extends HBoxContainer
class_name ActionBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for a:Action in get_children():
		a.set_icon()


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
