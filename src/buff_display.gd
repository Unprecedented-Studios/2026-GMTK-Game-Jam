extends HBoxContainer

@export var buff_type:Buff.Buff_list = Buff.Buff_list.AccuracyUp
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$Buff.type = buff_type
	$Buff.set_icon()
	$Label.text = $Buff.buff_info[buff_type]["info"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
