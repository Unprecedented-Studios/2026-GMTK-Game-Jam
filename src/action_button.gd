extends TextureRect


enum actions_list {BasicAttack, SmallHeal, Heal, HealOverTime, AOEHeal,Dispell, Shield,Resist}
@export var action_type:actions_list = actions_list.BasicAttack

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
	actions_list.BasicAttack:{"tooltip":"Basic magic attack - deals a small amount of damage", "mana":0},
	actions_list.SmallHeal:{"tooltip":"Small Heal - small heal with short cooldown","mana":0},
	actions_list.Heal:{"tooltip":"Heal - a powerful single target heal","mana":0},
	actions_list.HealOverTime:{"tooltip":"Heal Over Time - applys a buff to an ally to heal them slowly","mana":0},
	actions_list.AOEHeal:{"tooltip":"Multi-heal - Heals all party members, but requires lots of mana","mana":0},
	actions_list.Dispell:{"tooltip":"Dispell - Removes all Debuffs on an ally","mana":0},
	actions_list.Shield:{"tooltip":"Shield - Provides a shield that blocks all damage on an ally for a short time","mana":0},
	actions_list.Resist:{"tooltip":"Resist - Provides a buff that prevents any debuffs from being applied to an ally.","mana":0},
}

func _ready() -> void:
	for c in actions.keys():
		if c != action_type:
			actions[c].queue_free()
		else:
			actions[c].show()
			self.tooltip_text = action_information[action_type]["tooltip"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
