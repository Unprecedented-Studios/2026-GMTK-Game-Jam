extends Node

var actions:Array[Action]
func _ready():
	#set up initial arrays of allies and enemies


	actions = $ActionBar.get_actions()
	for a:Action in actions:
		a.action_attempt.connect(perform_action)

func _input(event: InputEvent) -> void:
	if mouse_over_actions:
		return
	var selected_char = get_selected_character()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and selected_char != null:
		for e:Character in $Enemies.get_children():
			if e.selected and !e.mouse_over_me:
				e.selected = false
		for a:Character in $Allies.get_children():
			if a.selected and !a.mouse_over_me:
				a.selected = false
func get_selected_character() -> Character:
	for e:Character in $Enemies.get_children():
		if e.selected:
			return e
	for a:Character in $Allies.get_children():
		if a.selected:
			return a
	return null

#function used by all the action buttons.  determine if action is possible
#then use it.
func perform_action(act:Action):
	var selected_character = get_selected_character()
	if selected_character == null:
		return
	else:
		act.activate()

var mouse_over_actions:bool = false
func _on_action_bar_area_mouse_entered() -> void:
	mouse_over_actions = true
func _on_action_bar_area_mouse_exited() -> void:
	mouse_over_actions = false
