extends CenterContainer
class_name UpgradeOption
@export var option_number:int = 0
var my_upgrade:Upgrade;

@onready var upgrade_image_slot: Marker2D = $"MarginContainer/OtherUpgrade/Upgrade Box/UpgradeImage"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.custom_minimum_size = size
	#set_upgrade_option(action_type)

func set_upgrade_option(upgrade:Upgrade, level:int = 0):
	if !upgrade:
		hide()
		return
		
	my_upgrade = upgrade;
	
	$MarginContainer/ActionDisplay.hide()
	$MarginContainer/OtherUpgrade.hide()
	if (upgrade.type() == "action"):
		$MarginContainer/ActionDisplay.show()
		var action_type = (upgrade as Action).action_button_id;
		$MarginContainer/ActionDisplay.set_action_display(action_type,level)
		clear_selection()
	else:
		for child in  upgrade_image_slot.get_children():
			upgrade_image_slot.remove_child(child)
			child.queue_free();
			
		$MarginContainer/OtherUpgrade.show()
		$MarginContainer/OtherUpgrade/UpgradeLabel.text = upgrade.info
		upgrade.icon.show();
		$"MarginContainer/OtherUpgrade/Upgrade Box/UpgradeImage".add_child(upgrade.icon.duplicate())

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
	
