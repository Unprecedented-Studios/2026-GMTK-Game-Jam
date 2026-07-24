extends HBoxContainer

@export var action_type:Action.actions_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_action_display(action_type)

func set_action_display(_type: Action.actions_list):
	$ActionButton.action_type = _type
	$ActionButton.set_icon()
	$Label.text = $ActionButton.action_information[action_type]["info"]
	
