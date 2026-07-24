extends CenterContainer
class_name UpgradeOption
@export var option_number:int = 0
var action_type:Action.actions_list
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.custom_minimum_size = size
	set_upgrade_option(action_type)

func set_upgrade_option(type:Action.actions_list):
	action_type = type
	$MarginContainer/ActionDisplay.set_action_display(type)
	clear_selection()

signal option_chosen

func _on_button_button_up() -> void:
	option_chosen.emit(option_number)
	
func draw_selection():
	var x_point = (size.x/2) 
	var y_point = (size.y/2)
	$Line2D.position = size/2
	$Line2D.add_point(Vector2(-x_point,y_point))
	$Line2D.add_point(Vector2(x_point,y_point))
	$Line2D.add_point(Vector2(x_point,-y_point))
	$Line2D.add_point(Vector2(-x_point,-y_point))
	$Line2D.show()
	
func clear_selection():
	$Line2D.hide()
	$Line2D.clear_points()
	
