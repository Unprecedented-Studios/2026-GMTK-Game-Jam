extends HBoxContainer

@export var action_type:Action.actions_list


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_action_display(action_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_action_display(action_type: Action.actions_list):
	$ActionButton.action_type = action_type
	$ActionButton.set_icon()
	$Label.text = $ActionButton.action_information[action_type]["info"]
	
