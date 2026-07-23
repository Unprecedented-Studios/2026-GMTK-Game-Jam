extends TextureRect
class_name Action

enum actions_list {BasicAttack, SmallHeal, Heal, HealOverTime, AOEHeal,Dispell, Shield,Resist}
@export var action_type:actions_list = actions_list.BasicAttack

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

var action_information:Dictionary = {
	actions_list.BasicAttack:{"tooltip":"Basic magic attack - deals a small amount of damage", "mana":0, "key":"Q","key_code":KEY_Q,"cooldown":1},
	actions_list.SmallHeal:{"tooltip":"Small Heal - small heal with short cooldown","mana":0, "key":"W","key_code":KEY_W,"cooldown":1},
	actions_list.Heal:{"tooltip":"Heal - a powerful single target heal","mana":0, "key":"E","key_code":KEY_E,"cooldown":10},
	actions_list.HealOverTime:{"tooltip":"Heal Over Time - applys a buff to an ally to heal them slowly","mana":0,"key":"R","key_code":KEY_R,"cooldown":5},
	actions_list.AOEHeal:{"tooltip":"Multi-heal - Heals all party members, but requires lots of mana","mana":0, "key":"A","key_code":KEY_A,"cooldown":15},
	actions_list.Dispell:{"tooltip":"Dispell - Removes all Debuffs on an ally","mana":0, "key":"S","key_code":KEY_S,"cooldown":5},
	actions_list.Shield:{"tooltip":"Shield - Provides a shield that blocks all damage on an ally for a short time","mana":0, "key":"D","key_code":KEY_D,"cooldown":15},
	actions_list.Resist:{"tooltip":"Resist - Provides a buff that prevents any debuffs from being applied to an ally.","mana":0, "key":"F","key_code":KEY_F,"cooldown":5},
}

func _ready() -> void:
	for c in actions.keys():
		if c != action_type:
			actions[c].queue_free()
		else:
			actions[c].show()
			self.tooltip_text = action_information[action_type]["tooltip"]
			cooldown_count_down = action_information[action_type]["cooldown"]
			$HotkeyLabel.text = action_information[action_type]["key"]

var cooldown_count_down:int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self_modulate.a < 1:
		self_modulate.a += delta
	

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(action_information[action_type]["key_code"]):
		act()

func act():
	action_attempt.emit(self)
	self_modulate.a = .7
	
func activate():
	if not $DurationTimer.is_stopped():
		return
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
	
