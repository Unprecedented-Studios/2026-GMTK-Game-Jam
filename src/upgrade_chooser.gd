extends Panel

@onready var options_array:Array[UpgradeOption]= \
[
	$vbox/Upgrade_Options/UpgradeOption, 
	$vbox/Upgrade_Options/UpgradeOption2, 
	$vbox/Upgrade_Options/UpgradeOption3
]
var selected_option:int = -1
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func display_upgrade_chooser(options_taken:Array[Action.actions_list]):
	var upgrade_bag:Array[Action.actions_list] = Action.get_array_of_actions()
	for u:Action.actions_list in options_taken:
		upgrade_bag.remove_at(upgrade_bag.find(u))
	randomize()
	upgrade_bag.shuffle()
	for opt:UpgradeOption in options_array:
		opt.set_upgrade_option(upgrade_bag.pop_front())
	$vbox/Upgrade_Options/Confirm.disabled = true
	self.show()
	for opt:UpgradeOption in options_array:
		opt.update_button_size()

func _on_upgrade_option_chosen(option_num:int = -1) -> void:
	selected_option = option_num
	for uo:UpgradeOption in options_array:
		uo.clear_selection()
	options_array[selected_option].draw_selection()
	$vbox/Upgrade_Options/Confirm.disabled = false

func _on_confirm_button_up() -> void:
	hide()
