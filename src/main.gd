extends Node

var actions:Array[Action]
func _ready():
	#set up initial arrays of allies and enemies


	actions = $ActionBar.get_actions()
	for a:Action in actions:
		a.action_attempt.connect(perform_action)
		
func get_characters() -> Array[Character]:
	var characters:Array[Character] =[]
	for a:Character in $Allies.get_children():
		characters.append(a)
	for e:Character in $Enemies.get_children():
		characters.append(e)
	return characters

func _input(event: InputEvent) -> void:
	if mouse_over_actions:
		return

	var selected_char = get_selected_character()
	#mouse selection handling
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and selected_char != null:
		for c:Character in get_characters():
			if c.selected and !c.mouse_over_me:
				c.selected = false
	#tab_targeting.
	if event.is_action_released("tab"):
		if selected_char == null:
			var a:Character = $Allies.get_child(0)
			a.selected = true
			return
		if Input.is_key_pressed(KEY_SHIFT):
			var tabbable_targets = get_characters()
			var selected_index:int = tabbable_targets.find(selected_char)
			if selected_index == 0:
				tabbable_targets[tabbable_targets.size()-1].selected = true
			else:
				tabbable_targets[selected_index-1].selected = true
			selected_char.selected = false
		else: #shift isn't held and we should normal tab
			var tabbable_targets = get_characters()
			var selected_index:int = tabbable_targets.find(selected_char)
			if selected_index == tabbable_targets.size()-1:
				tabbable_targets[0].selected = true
			else:
				tabbable_targets[selected_index+1].selected = true
			selected_char.selected = false
			
		
				
	
func get_selected_character() -> Character:
	for c:Character in get_characters():
		if c.selected:
			return c
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
