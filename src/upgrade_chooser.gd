extends Panel

@onready var options_array:Array[UpgradeOption]= \
[
	$vbox/Upgrade_Options/UpgradeOption, 
	$vbox/Upgrade_Options/UpgradeOption2, 
	$vbox/Upgrade_Options/UpgradeOption3
]


var selected_option:int = -1
var character_list: Array[NewCharacter]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_list = $UpgradeLists.get_new_allies();

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
func display_upgrade_chooser(options_taken:Array[Action_Button]):
	get_tree().paused = true
	var available_actions = Action_Button.get_array_of_actions()
	var upgrade_bag:Array[Upgrade] = []
	#if they already have a full bar, we start upgrades for what they have,
	#otherwise we'll remove the options they have.
	self.show()
	$vbox/Upgrade_Options/NoMoreUpgradesLabel.hide()
	for o in options_array:
		o.show()
	var action_upgrade:Action;

	if options_taken.size() == available_actions.size():
		for a:Action_Button in options_taken:
			if a.upgrade_level < 3:
				action_upgrade = Action.new();
				action_upgrade.action_button_id = a.action_type
				upgrade_bag.append(action_upgrade)
	else:
		for a:Action_Button in options_taken:
			available_actions.erase(a.action_type)
		for a_type:Action_Button.actions_list in available_actions:
				action_upgrade = Action.new();
				action_upgrade.action_button_id = a_type
				upgrade_bag.append(action_upgrade)

	randomize()
	upgrade_bag.shuffle()
	
	#options for upgrades
	for opt:UpgradeOption in options_array:
		var upgrade_type:Upgrade = upgrade_bag.pop_front()
		if upgrade_type.type() == "action":
			action_upgrade = upgrade_type as Action;
			if options_taken.size() == available_actions.size():
				var current_action_level:int = 1
				for a:Action_Button in options_taken:
					if a.action_type == action_upgrade.action_button_id:
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
	
