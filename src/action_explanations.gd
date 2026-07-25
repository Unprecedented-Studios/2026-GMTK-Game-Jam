extends VBoxContainer


var action_display_preload = preload("res://scenes/ActionDisplay.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var basic_attack:ActionDisplay = action_display_preload.instantiate()
	basic_attack.set_action_display(Action_Button.actions_list.BasicAttack)
	$ActionList.add_child(basic_attack)
	var small_heal:ActionDisplay = action_display_preload.instantiate()
	small_heal.set_action_display(Action_Button.actions_list.SmallHeal)
	$ActionList.add_child(small_heal)
	

func reset():
	for c in $ActionList.get_children():
		c.queue_free()
	_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_explanation(new_explanation:Action_Button.actions_list):
	for ad:ActionDisplay in $ActionList.get_children():
		if ad.type == new_explanation:
			return
	var new_display:ActionDisplay = action_display_preload.instantiate()
	new_display.set_action_display(new_explanation)
	$ActionList.add_child(new_display)
	
