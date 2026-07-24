extends HBoxContainer

# Called when the node enters the scene tree for the first time.

func set_action_display(_type: Action.actions_list, level:int =0):
	$ActionButton.action_type = _type
	$ActionButton.set_icon()
	$ActionButton.set_upgrade_level(level)
	$Label.text = Action.action_information[_type]["info"]
	
