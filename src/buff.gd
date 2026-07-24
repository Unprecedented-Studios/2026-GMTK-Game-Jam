extends TextureRect
class_name Buff

enum Buff_list {AccuracyUp, AccuracyDown, AttackUp, AttackDown, 
				DefenseUp,DefenseDown,SpeedUp,SpeedDown, Shield,HealOverTime, 
				Resist,
				none}
				
var buff_info:Dictionary =\
{
	Buff_list.AccuracyUp:{"info":"Accuracy Up - Increases chances of hitting"},
	Buff_list.AccuracyDown:{"info":"Accuracy Down - Decreases chances of hitting"},
	Buff_list.AttackUp:{"info":"Attack Up - Increases damage of attacks"},
	Buff_list.AttackDown:{"info":"Attack Down - Decreases Damage of Attacks"},
	Buff_list.DefenseUp:{"info":"Defense Up - Decreases damage taken from attacks"},
	Buff_list.DefenseDown:{"info":"Defense Down - Increases Damage taken from attacks"},
	Buff_list.SpeedUp:{"info":"Speed Up - Increases frequency of attacks"},
	Buff_list.SpeedDown:{"info":"Speed Down - Decreases Frequency of attacks"},
	Buff_list.Shield:{"info":"Shield - Prevents damage from attacks"},
	Buff_list.HealOverTime:{"info":"Heal Over Time - Slowly heals"},
	Buff_list.Resist:{"info":"Resist - Prevents Debuffs from being applied"},
	
}

@onready var buff_icons =\
{
	Buff_list.AccuracyUp:$AccuracyUp,
	Buff_list.AccuracyDown:$AccuracyDown,
	Buff_list.AttackUp:$AttackUp,
	Buff_list.AttackDown:$AttackDown,
	Buff_list.DefenseUp:$DefenseUp,
	Buff_list.DefenseDown:$DefenseDown,
	Buff_list.SpeedUp:$SpeedUp,
	Buff_list.SpeedDown:$SpeedDown,
	Buff_list.Shield:$Shield,
	Buff_list.HealOverTime:$HealOverTime,
	Buff_list.Resist:$Resist,
	
}




var buff_duration_seconds:float = 5
signal heal_tick
var heal_amount:int = 5
@export var type:Buff_list = Buff_list.none
@export var instructional:bool = false
var debuff:bool:
	get:
		match type:
			Buff_list.AccuracyDown: return true
			Buff_list.AttackDown: return true
			Buff_list.DefenseDown: return true
			Buff_list.SpeedDown: return true
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
	if type == Buff_list.HealOverTime:
		heal_tick.emit(heal_amount)
	$BuffCountdown.text = str(int(round($DurationTimer.time_left)))
