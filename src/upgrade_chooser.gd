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


func _on_upgrade_option_chosen(option_num:int = -1) -> void:
	selected_option = option_num
	for uo:UpgradeOption in options_array:
		uo.clear_selection()
	options_array[selected_option].draw_selection()
