extends TextureRect
class_name Action_Button

@export var action: Action; 

enum actions_list {BasicAttack, SmallHeal, Heal, HealOverTime, 
AOEHeal, Shield,AttackUp,AttackDown, 
DefenseUp,DefenseDown,SpeedUp,SpeedDown}

static func get_array_of_actions() -> Array[actions_list]:
	return [actions_list.BasicAttack, actions_list.SmallHeal, actions_list.Heal, actions_list.HealOverTime,
	actions_list.AOEHeal, actions_list.Shield,actions_list.AttackUp,actions_list.AttackDown, 
	actions_list.DefenseUp,actions_list.DefenseDown,actions_list.SpeedUp,actions_list.SpeedDown]
@export var action_type:actions_list = actions_list.BasicAttack
@export var instructional:bool = false
signal action_attempt(Action_Button)

var assigned_key:Key = KEY_0
var upgrade_level:int = 0
var duration:int = 0
var cooldown:int = 0
var cooldown_count_down:int = 0
var amount:float = 0.0
var is_ready:bool:
	get:
		return $DurationTimer.is_stopped()
@onready var actions:Dictionary = \
{
	actions_list.BasicAttack:$BasicAttack,
	actions_list.SmallHeal:$SmallHeal,
	actions_list.Heal:$Heal,
	actions_list.HealOverTime:$HealOverTime,
	actions_list.AOEHeal:$AOEHeal,
	actions_list.Shield:$Shield,
	actions_list.AttackUp:$AttackUp,
	actions_list.AttackDown:$AttackDown,
	actions_list.DefenseUp:$DefenseUp,
	actions_list.DefenseDown:$DefenseDown,
	actions_list.SpeedUp:$SpeedUp,
	actions_list.SpeedDown:$SpeedDown,
}

static var action_information:Dictionary = {
	actions_list.BasicAttack:{"info":"Basic magic attack - deals a small amount of damage", "mana":0, "cooldown":2,"amount":5},
	actions_list.SmallHeal:{"info":"Small Heal - small heal with short cooldown","mana":0,"cooldown":4,"amount":10},
	actions_list.Heal:{"info":"Heal - a powerful single target heal","mana":0, "cooldown":10,"amount":30},
	actions_list.HealOverTime:{"info":"Heal Over Time - Heals slowly","mana":0,"cooldown":10,"duration":5,"amount":5.0},
	actions_list.AOEHeal:{"info":"Multi-heal - Heals all party members","mana":0,"cooldown":20,"amount":15},
	actions_list.Shield:{"info":"Shield - A shield that blocks all damage for a short time","mana":0,"cooldown":20, "duration":3},
	actions_list.AttackUp:{"info":"Attack Up - Increases attack damage","mana":0,"cooldown":10, "duration":5,"amount":1.25},
	actions_list.AttackDown:{"info":"Attack Down - Decrease attack damage","mana":0,"cooldown":10, "duration":5,"amount":0.75},
	actions_list.DefenseUp:{"info":"Defense Up - Increases attack speed","mana":0,"cooldown":10, "duration":5,"amount":1.25},
	actions_list.DefenseDown:{"info":"Defense Down - Increases attack speed","mana":0,"cooldown":10, "duration":5,"amount":0.75},
	actions_list.SpeedUp:{"info":"Speed Up - Increases attack speed","mana":0,"cooldown":10, "duration":5,"amount":1.25},
	actions_list.SpeedDown:{"info":"Speed Down - Decreases attack speed","mana":0,"cooldown":10, "duration":0.75},
}

func _ready() -> void:
	pass
	

func set_icon():
	for c in actions.keys():
		if c != action_type:
			actions[c].hide()
		else:
			actions[c].show()
			if instructional:
				continue
			self.tooltip_text = action_information[action_type]["info"]
			cooldown = action_information[action_type]["cooldown"]
			if action_information[action_type].has("duration"):
				duration = action_information[action_type]["duration"]
			if action_information[action_type].has("amount"):
				amount = action_information[action_type]["amount"]

func upgrade():
	upgrade_level +=1
	if upgrade_level ==1:
		cooldown *= .5
	elif upgrade_level ==2:
		if duration >0:
			duration *=2
		else:
			amount *= 2
	elif upgrade_level == 3:
		if duration >0 and amount >1:
			amount *= 1.5
		elif duration >0 and amount <1:
			amount *= .6
		else:
			amount *= 2
	set_upgrade_level(upgrade_level)

func set_upgrade_level(new_level:int=0):
	upgrade_level = new_level
	if upgrade_level == 0:
		$UpgradeLabel.text = ""
		$UpgradeLabel2.text = ""
		cooldown = action_information[action_type]["cooldown"]
		if action_information[action_type].has("duration"):
			duration = action_information[action_type]["duration"]
		if action_information[action_type].has("amount"):
			amount = action_information[action_type]["amount"]
	else:
		$UpgradeLabel.text = "+" + str(new_level)
		$UpgradeLabel2.text = $UpgradeLabel.text


func set_key(key_text:String, key_code:Key):
	$HotkeyLabel.text = key_text
	$HotkeyLabel2.text = key_text
	assigned_key = key_code
	
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self_modulate.a < 1:
		self_modulate.a += delta
	

func _input(_event: InputEvent) -> void:
	if assigned_key == KEY_0:
		return
	if Input.is_key_pressed(assigned_key):
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
	cooldown_count_down = cooldown
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
	
