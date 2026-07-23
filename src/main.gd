extends Node

var actions:Array[Action]
func _ready():
	get_tree().paused = true

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
	if event.is_action_released("Escape"):
		get_tree().paused = true
		$StartMenu.show()
		$StartMenu/VBoxContainer/MainMenu/PauseMenu.show()
		$StartMenu/VBoxContainer/MainMenu/StartButton.hide()
		$StartMenu/VBoxContainer/MainMenu/PauseMenu/ReturnToGame.show()
		
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
var small_heal_amount:int = 10
var heal_amount:int = 50
var aoe_heal_amount:int = 20
var basic_attack_damage:DamageInfo = DamageInfo.new()

var buff_preload = preload("res://scenes/buff.tscn")

func perform_action(act:Action):
	var selected_character = get_selected_character()
	if selected_character == null:
		return
	elif act.is_ready:
		act.activate()
		if act.action_type == Action.actions_list.SmallHeal:
			selected_character.heal(small_heal_amount)
		elif act.action_type == Action.actions_list.Heal:
			selected_character.heal(heal_amount)
		elif act.action_type == Action.actions_list.AOEHeal:
			for a:Character in $Allies:
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
	get_tree().paused = false


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
