extends Node

var actions:Array[Action_Button]

func _ready():
	$StartMenu.show()
	var load_actions = $ActionBar.get_actions()
	for a:Action_Button in load_actions:
		a.action_attempt.connect(perform_action)
	GameState.game_over.connect(_on_game_state_game_over)
	GameState.enemy_died.connect(_on_game_state_enemy_died)
		
func get_characters() -> Array[Character]:
	return GameState.active_allies
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("Escape"):
		$StartMenu/MenuSound.play()
		get_tree().paused = true
		$StartMenu.show()
		$StartMenu/VBoxContainer/MainMenu/PauseMenu.show()
		$StartMenu/VBoxContainer/MainMenu/StartButton.hide()
		$StartMenu/VBoxContainer/MainMenu/PauseMenu/ReturnToGame.show()
		
	
	#tab_targeting.
	if event.is_action_released("tab"):
		var selected_char = get_selected_character()
		if selected_char == null:
			if GameState.active_allies.size() > 0:
				var a:Character = GameState.active_allies[0]
				a.selected = true
			return
		
		
		var tabbable_targets = get_characters()
		var selected_index:int = tabbable_targets.find(selected_char)
		selected_char.selected = false
		if Input.is_key_pressed(KEY_SHIFT):
			if selected_index == 0:
				tabbable_targets[tabbable_targets.size()-1].selected = true
			else:
				tabbable_targets[selected_index-1].selected = true
		else: #shift isn't held and we should normal tab
			if selected_index == tabbable_targets.size()-1:
				tabbable_targets[0].selected = true
			else:
				tabbable_targets[selected_index+1].selected = true


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
var action_preload = preload("res://scenes/action_button.tscn")

func perform_action(act:Action_Button):
	var selected_character = get_selected_character()
	if selected_character == null or not act.is_ready:
		act.play_rejected_sound()
		return
	elif act.is_ready:
		act.activate()
		if act.action_type == Action_Button.actions_list.SmallHeal:
			selected_character.heal(small_heal_amount)
		elif act.action_type == Action_Button.actions_list.Heal:
			selected_character.heal(heal_amount)
		elif act.action_type == Action_Button.actions_list.AOEHeal:
			for a:Character in GameState.active_allies:
				a.heal(aoe_heal_amount)
		elif act.action_type == Action_Button.actions_list.BasicAttack:
			basic_attack_damage.damage = 5.0
			selected_character.take_damage(basic_attack_damage)
		#if it's a buff...
		elif act.duration >0:
			var new_buff = buff_preload.instantiate()
			new_buff.type = act.action_type
			new_buff.buff_duration_seconds = float(act.duration)
			new_buff.buff_amount = act.amount
			selected_character.apply_buff(new_buff)

func _on_start_button_button_up() -> void:
	$StartMenu.hide()
	GameState.start_game()
	#"Tutorial"
	var tutTime = Timer.new()
	add_child(tutTime)
	tutTime.one_shot = true
	tutTime.timeout.connect(
		func():
			$TutorialInfo.modulate.a = 0;
			$TutorialInfo.show()
			var t = get_tree().create_tween()
			t.tween_property($TutorialInfo, "modulate:a",1,1);
	);
	tutTime.start(7)


#region Instructions stuff
var active_instruction = 0
@onready var instructions:Array[VBoxContainer] =\
[
	$StartMenu/VBoxContainer/BasicInstructions, 
	$StartMenu/VBoxContainer/ActionInstructions
]

func _on_how_to_play_button_down() -> void:
	active_instruction = 0
	for i:VBoxContainer in instructions:
		i.hide()
	instructions[active_instruction].show()
	$StartMenu/VBoxContainer/HBoxContainer/BackButton.show()
	# for now I'm thinking we just have the basic instructions since the 
	# upgrade window tells you what things do.
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
	GameState.start_game()
	$ActionBar.reset()
	$StartMenu/VBoxContainer/ActionInstructions.reset()

func _on_return_to_game_button_up():
	$StartMenu.hide()
	get_tree().paused = false;


func _on_upgrade_chooser_upgrade_chosen(upgrade:Upgrade) -> void:
	if upgrade:
		if (upgrade.type() == 'action'):
			var type:Action_Button.actions_list = (upgrade as Action).action_button_id; 
			var current_player_action_types:Array[Action_Button.actions_list] = $ActionBar.get_action_types()
			if current_player_action_types.find(type) > -1:
				$ActionBar.get_action(type).upgrade()
			else:
				var new_action:Action_Button = action_preload.instantiate()
				new_action.action_type = type
				$ActionBar.add_action(new_action)
				new_action.set_icon()
				new_action.action_attempt.connect(perform_action)
				$StartMenu/VBoxContainer/ActionInstructions.add_explanation(type)
		elif upgrade.type() == 'character':
			GameState.spawn_hero((upgrade as NewCharacter).character_class, upgrade.upgradeID)
	else:
		GameState.no_more_upgrades = true;
		
	$ActionBar.reset_timers()
	GameState.increase_player_level();
	transition_to_next_enemy()


		

func _on_game_state_enemy_died() -> void:
	if $TutorialInfo.visible:
		$TutorialInfo.hide()
	if GameState.no_more_upgrades:
		_on_upgrade_chooser_upgrade_chosen(null)
	else:
		$UpgradeChooser.display_upgrade_chooser($ActionBar.get_actions(), GameState.active_allies)


func _on_debug_pressed() -> void:
	$MapTreadmill.shift_map()
	#$UpgradeChooser.display_upgrade_chooser($ActionBar.get_actions(), GameState.active_allies);
	
	
func transition_to_next_enemy():
	$MapTreadmill.shift_map()
	GameState.spawn_next_enemy()
	for c:Character in GameState.active_allies:
		if c.is_alive:
			c.walk()
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(c,"position",Vector2(c.position.x - 512.0,c.position.y),2.0)
			tween.parallel().tween_property(c,"modulate:a",0.0,1.0)
			await tween.finished
			GameState.active_allies.erase(c) #probably te wrong way to do this
			c.queue_free()
			return;
	GameState.allow_attacks(false)
		
func _on_map_treadmill_walk_done() -> void:
	GameState.allow_attacks(true)
	for c:Character in GameState.active_allies:
		c.stop()
