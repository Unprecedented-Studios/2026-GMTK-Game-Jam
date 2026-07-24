extends HBoxContainer

# Called when the node enters the scene tree for the first time.

func set_action_display(_type: Action.actions_list):
	$ActionButton.action_type = _type
	$ActionButton.set_icon()
	$Label.text = Action.action_information[_type]["info"]
	
