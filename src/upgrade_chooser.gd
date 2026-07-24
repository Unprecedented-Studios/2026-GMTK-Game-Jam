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
func display_upgrade_chooser(options_taken:Array[Action]):
	get_tree().paused = true
	var upgrade_bag:Array[Action.actions_list] = Action.get_array_of_actions()
	#if they already have a full bar, we start upgrades for what they have,
	#otherwise we'll remove the options they have.
	self.show()
	$vbox/Upgrade_Options/NoMoreUpgradesLabel.hide()
	for o in options_array:
		o.show()
	if options_taken.size() == 8:
		upgrade_bag = []
		for a:Action in options_taken:
			if a.upgrade_level < 3:
				upgrade_bag.append(a.action_type)
	else:
		for a:Action in options_taken:
			upgrade_bag.remove_at(upgrade_bag.find(a.action_type))
	randomize()
	upgrade_bag.shuffle()
	
	#options for upgrades
	for opt:UpgradeOption in options_array:
		var upgrade_type = upgrade_bag.pop_front()
		if options_taken.size() == 8:
			var current_action_level:int = 1
			for a:Action in options_taken:
				if a.action_type == upgrade_type:
					current_action_level = a.upgrade_level
			if upgrade_type == null:
				opt.hide()
			else:
				opt.set_upgrade_option(upgrade_type,current_action_level+1)
		else:
			opt.set_upgrade_option(upgrade_type)
		
		
	$vbox/Upgrade_Options/Confirm.disabled = true
	
	if !$vbox/Upgrade_Options/UpgradeOption.visible and \
		!$vbox/Upgrade_Options/UpgradeOption2.visible and \
		!$vbox/Upgrade_Options/UpgradeOption3.visible:
			
		$vbox/Upgrade_Options/NoMoreUpgradesLabel.show()
		$vbox/Upgrade_Options/Confirm.disabled = false
	
func _on_upgrade_option_chosen(option_num:int = -1) -> void:
	selected_option = option_num
	for uo:UpgradeOption in options_array:
		uo.clear_selection()
	options_array[selected_option].draw_selection()
	$vbox/Upgrade_Options/Confirm.disabled = false

signal upgrade_chosen

func _on_confirm_button_up() -> void:
	hide()
	get_tree().paused = false
	if $vbox/Upgrade_Options/NoMoreUpgradesLabel.visible:
		return
	upgrade_chosen.emit(options_array[selected_option].action_type)
	
