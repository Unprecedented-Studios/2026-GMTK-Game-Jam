class_name StatusBox
extends VBoxContainer

@onready var health_label:Label = $HBoxContainer/Health
@onready var max_health_label:Label = $HBoxContainer/MaxHealth
@onready var health_bar:ProgressBar = $HealthBar
@onready var buffs_and_debuffs:GridContainer = $BuffsAndDebuffs
# Called when the node enters the scene tree for the first time.
var max_health:int = 100:
	set(new_max_health):
		max_health = new_max_health
		max_health_label.value = str(max_health)
		
		
var health: int = 100:
	get:
		return health
	set(new_health):
		health = clampi(new_health,0, max_health)
		health_bar.value = (float(health)/float(max_health))
		health_label.text = str(health)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
