extends HBoxContainer
class_name ActionDisplay
# Called when the node enters the scene tree for the first time.


var type:Action_Button.actions_list
func _ready() -> void:
	$ActionButton.set_icon()
	
func set_action_display(_type: Action_Button.actions_list, level:int =0):
	type = _type
	$ActionButton.action_type = _type
	$ActionButton.set_icon()
	$ActionButton.set_upgrade_level(level)
	$Label.text = Action_Button.action_information[_type]["info"]
	
