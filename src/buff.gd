extends TextureRect
class_name Buff

				
var buff_info:Dictionary =\
{
	Action.actions_list.AttackUp:{"info":"Attack Up - Increases damage of attacks"},
	Action.actions_list.AttackDown:{"info":"Attack Down - Decreases Damage of Attacks"},
	Action.actions_list.DefenseUp:{"info":"Defense Up - Decreases damage taken from attacks"},
	Action.actions_list.DefenseDown:{"info":"Defense Down - Increases Damage taken from attacks"},
	Action.actions_list.SpeedUp:{"info":"Speed Up - Increases frequency of attacks"},
	Action.actions_list.SpeedDown:{"info":"Speed Down - Decreases Frequency of attacks"},
	Action.actions_list.Shield:{"info":"Shield - Prevents damage from attacks"},
	Action.actions_list.HealOverTime:{"info":"Heal Over Time - Slowly heals"},
	
}

@onready var buff_icons =\
{
	Action.actions_list.AttackUp:$AttackUp,
	Action.actions_list.AttackDown:$AttackDown,
	Action.actions_list.DefenseUp:$DefenseUp,
	Action.actions_list.DefenseDown:$DefenseDown,
	Action.actions_list.SpeedUp:$SpeedUp,
	Action.actions_list.SpeedDown:$SpeedDown,
	Action.actions_list.Shield:$Shield,
	Action.actions_list.HealOverTime:$HealOverTime,
	
}


var type:Action.actions_list = Action.actions_list.HealOverTime

var buff_duration_seconds:float = 5
signal heal_tick
var heal_amount:int = 5
var buff_amount:float = 1.5
@export var instructional:bool = false
var debuff:bool:
	get:
		match Action.actions_list:
			Action.actions_list.AttackDown: return true
			Action.actions_list.DefenseDown: return true
			Action.actions_list.SpeedDown: return true
		return false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if instructional:
		$DurationCover.queue_free()
		return
	$TickTimer.start()
	$DurationTimer.start(buff_duration_seconds)
	$BuffCountdown.text = str(int(round(buff_duration_seconds)))
	set_icon()

func set_icon():
	for c in buff_info.keys():
		if c != type:
			buff_icons[c].queue_free()
	buff_icons[type].show()
	$DurationCover.tooltip_text = buff_info[type]["info"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if instructional:
		return
	$DurationCover.value =  (buff_duration_seconds-$DurationTimer.time_left)/buff_duration_seconds


func _on_duration_timer_timeout() -> void:
	self.queue_free()


func _on_tick_timer_timeout() -> void:
	if type == Action.actions_list.HealOverTime:
		heal_tick.emit(heal_amount)
	$BuffCountdown.text = str(int(round($DurationTimer.time_left)))
