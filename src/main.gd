extends Node

var actions:Array[Action]
func _ready():
	$StartMenu.show()
	actions = $ActionBar.get_actions()
	for a:Action in actions:
		a.action_attempt.connect(perform_action)
		
func get_characters() -> Array[Character]:
	return $GameState.all_characters
	
func _input(event: InputEvent) -> void:
	if mouse_over_actions:
		return
	if event.is_action_released("Escape"):
		$StartMenu/MenuSound.play()
		get_tree().paused = true
		$StartMenu.show()
		$StartMenu/VBoxContainer/MainMenu/PauseMenu.show()
		$StartMenu/VBoxContainer/MainMenu/StartButton.hide()
		$StartMenu/VBoxContainer/MainMenu/PauseMenu/ReturnToGame.show()
		
	var selected_char = get_selected_character()
	#mouse selection handling
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and selected_char != null:
		for c:Character in get_characters():
			if c and c.selected and !c.mouse_over_me:
				c.selected = false
	#tab_targeting.
	if event.is_action_released("tab"):
		if selected_char == null:
			var a:Character = $GameState.active_allies[0]
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
		if c and c.selected:
			return c
	return null

#function used by all the action buttons.  determine if action is possible
#then use it.
var small_heal_amount:int = 10
var heal_amount:int = 50
var aoe_heal_amount:int = 20
var basic_attack_damage:DamageInfo = DamageInfo.new()

var buff_preload = preload("res://scenes/buff.tscn")

func perform_action(act:Action):
	var selected_character = get_selected_character()
	if selected_character == null or not act.is_ready:
		act.play_rejected_sound()
		return
	elif act.is_ready:
		act.activate()
		if act.action_type == Action.actions_list.SmallHeal:
			selected_character.heal(small_heal_amount)
		elif act.action_type == Action.actions_list.Heal:
			selected_character.heal(heal_amount)
		elif act.action_type == Action.actions_list.AOEHeal:
			for a:Character in $GameState.active_allies:
				a.heal(aoe_heal_amount)
		elif act.action_type == Action.actions_list.BasicAttack:
			basic_attack_damage.damage = 5.0
			selected_character.take_damage(basic_attack_damage)
		elif act.action_type == Action.actions_list.HealOverTime:
			var new_HOT:Buff = buff_preload.instantiate()
			new_HOT.type = Buff.Buff_list.HealOverTime
			selected_character.apply_buff(new_HOT)
		elif act.action_type == Action.actions_list.Dispell:
			selected_character.dispell()
		elif act.action_type == Action.actions_list.Shield:
			var new_shield:Buff = buff_preload.instantiate()
			new_shield.type = Buff.Buff_list.Shield
			selected_character.apply_buff(new_shield)
		elif act.action_type == Action.actions_list.Resist:
			var new_resist:Buff = buff_preload.instantiate()
			new_resist.type = Buff.Buff_list.Resist
			selected_character.apply_buff(new_resist)

var mouse_over_actions:bool = false
func _on_action_bar_area_mouse_entered() -> void:
	mouse_over_actions = true
func _on_action_bar_area_mouse_exited() -> void:
	mouse_over_actions = false


func _on_start_button_button_up() -> void:
	$StartMenu.hide()
	$GameState.start_game()


#region Instructions stuff
var active_instruction = 0
@onready var instructions:Array[VBoxContainer] =\
[
	$StartMenu/VBoxContainer/BasicInstructions, 
	$StartMenu/VBoxContainer/ActionInstructions,
	$StartMenu/VBoxContainer/BuffInstructions
]

func _on_how_to_play_button_down() -> void:
	active_instruction = 0
	for i:VBoxContainer in instructions:
		i.hide()
	instructions[active_instruction].show()
	$StartMenu/VBoxContainer/HBoxContainer/BackButton.show()
	$StartMenu/VBoxContainer/HBoxContainer/NextButton.show()
	$StartMenu/VBoxContainer/MainMenu.hide()

func _on_back_button_button_up() -> void:
	if active_instruction == 0:
		for i:VBoxContainer in instructions:
			i.hide()
		$StartMenu/VBoxContainer/HBoxContainer/BackButton.hide()
		$StartMenu/VBoxContainer/HBoxContainer/NextButton.hide()
		$StartMenu/VBoxContainer/MainMenu.show()
	else:
		active_instruction -=1
		for i:VBoxContainer in instructions:
			i.hide()
		instructions[active_instruction].show()

func _on_next_button_button_up() -> void:
	if active_instruction == instructions.size()-1:
		for i:VBoxContainer in instructions:
			i.hide()
		$StartMenu/VBoxContainer/HBoxContainer/BackButton.hide()
		$StartMenu/VBoxContainer/HBoxContainer/NextButton.hide()
		$StartMenu/VBoxContainer/MainMenu.show()
	else:
		active_instruction +=1
		for i:VBoxContainer in instructions:
			i.hide()
		instructions[active_instruction].show()
#endregion

func _on_v_slider_drag_ended(_value_changed: bool) -> void:
	AudioServer.set_bus_volume_linear(0,$StartMenu/VBoxContainer/MainMenu/HBoxContainer/VolumeSlider.value/100.0)

func _on_background_music_finished() -> void:
	$StartMenu/BackgroundMusic.play()

func _on_game_state_game_over():
	$StartMenu.show()
	$StartMenu/VBoxContainer/MainMenu/PauseMenu.hide()
	$StartMenu/VBoxContainer/MainMenu/EndingMenu.show()
	$StartMenu/VBoxContainer/MainMenu/RestartGame.show()
	$StartMenu/VBoxContainer/MainMenu/StartButton.hide()

func _on_restart_game_button_up():
	$StartMenu.hide()
	$StartMenu/VBoxContainer/MainMenu/EndingMenu.hide()
	$StartMenu/VBoxContainer/MainMenu/RestartGame.hide()
	$StartMenu/VBoxContainer/MainMenu/StartButton.show()
	$GameState.start_game()

func _on_return_to_game_button_up():
	$StartMenu.hide()
	get_tree().paused = false;
