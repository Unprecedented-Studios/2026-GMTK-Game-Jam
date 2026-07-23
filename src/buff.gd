extends TextureRect
class_name Buff

enum Buff_list {none,AccuracyUp, AccuracyDown, AttackUp, AttackDown, 
				DefenseUp,DefenseDown,SpeedUp,SpeedDown, Shield,HealOverTime, 
				Resist}
				
@onready var buffs:Dictionary =\
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
	Buff_list.Resist:$Resist
	
}


var buff_duration_seconds:float = 5:
	set(duration):
		buff_duration_seconds = duration
		$DurationTimer.start(duration)
		

var type:Buff_list = Buff_list.none:
	set(new_type):
		for c in buffs.keys():
			if c != new_type:
				buffs[c].queue_free()
		if new_type != Buff_list.none:
			buffs[new_type].show()
	get:
		return type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c:Sprite2D in buffs.values():
		c.hide()
	$DurationTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$DurationCover.value =  (buff_duration_seconds-$DurationTimer.time_left)/buff_duration_seconds


func _on_duration_timer_timeout() -> void:
	self.queue_free()
