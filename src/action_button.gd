extends TextureRect
class_name Action

enum actions_list {BasicAttack, SmallHeal, Heal, HealOverTime, 
AOEHeal,Dispell, Shield, Resist}

static func get_array_of_actions() -> Array[actions_list]:
	return [actions_list.BasicAttack,actions_list.SmallHeal, actions_list.Heal,actions_list.HealOverTime,
	actions_list.AOEHeal,actions_list.Dispell, actions_list.Shield,actions_list.Resist]
@export var action_type:actions_list = actions_list.BasicAttack
@export var instructional:bool = false
signal action_attempt(Action)

@onready var actions:Dictionary = \
{
	actions_list.BasicAttack:$BasicAttack,
	actions_list.SmallHeal:$SmallHeal,
	actions_list.Heal:$Heal,
	actions_list.HealOverTime:$HealOverTime,
	actions_list.AOEHeal:$AOEHeal,
	actions_list.Dispell:$Dispell,
	actions_list.Shield:$Shield,
	actions_list.Resist:$Resist
}

static var action_information:Dictionary = {
	actions_list.BasicAttack:{"info":"Basic magic attack - deals a small amount of damage", "mana":0, "key":"Q","key_code":KEY_Q,"cooldown":1},
	actions_list.SmallHeal:{"info":"Small Heal - small heal with short cooldown","mana":0, "key":"W","key_code":KEY_W,"cooldown":1},
	actions_list.Heal:{"info":"Heal - a powerful single target heal","mana":0, "key":"E","key_code":KEY_E,"cooldown":10},
	actions_list.HealOverTime:{"info":"Heal Over Time - Heals slowly","mana":0,"key":"R","key_code":KEY_R,"cooldown":5},
	actions_list.AOEHeal:{"info":"Multi-heal - Heals all party members","mana":0, "key":"A","key_code":KEY_A,"cooldown":15},
	actions_list.Dispell:{"info":"Dispell - Removes all Debuffs on an ally","mana":0, "key":"S","key_code":KEY_S,"cooldown":5},
	actions_list.Shield:{"info":"Shield - A shield that blocks all damage for a short time","mana":0, "key":"D","key_code":KEY_D,"cooldown":15},
	actions_list.Resist:{"info":"Resist - Prevents any debuffs from being applied","mana":0, "key":"F","key_code":KEY_F,"cooldown":5},
}

func _ready() -> void:
	pass
var cooldown_count_down:int = 0
var is_ready:bool:
	get:
		return $DurationTimer.is_stopped()


	
func set_icon():
	for c in actions.keys():
		if c != action_type:
			actions[c].hide()
		else:
			actions[c].show()
			if instructional:
				continue
			self.tooltip_text = action_information[action_type]["info"]
			cooldown_count_down = action_information[action_type]["cooldown"]
			$HotkeyLabel.text = action_information[action_type]["key"]
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self_modulate.a < 1:
		self_modulate.a += delta
	

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(action_information[action_type]["key_code"]):
		act()

func act():
	if instructional:
		return
	action_attempt.emit(self)
	self_modulate.a = .7

func play_rejected_sound():
	$ActionRejectedSound.pitch_scale = randf_range(.95,1.05)
	$ActionRejectedSound.play()

	
func activate():
	$ActionSound.pitch_scale = randf_range(.95,1.05)
	$ActionSound.play()
	$DurationTimer.start()
	$DurationCover.show()
	cooldown_count_down = action_information[action_type]["cooldown"]
	$TimerLabel.text = str(cooldown_count_down)
	$TimerLabel.show()

func _on_duration_timer_timeout() -> void:
	if cooldown_count_down > 1:
		cooldown_count_down -= 1
		$TimerLabel.text = str(cooldown_count_down)
	else:
		$DurationTimer.stop()
		$DurationCover.hide()
		$TimerLabel.hide()


func _on_button_button_up() -> void:
	act()
	
