extends Node

@onready var character_list = get_node("characters")

func get_available_allies(already_loaded:Array[Character]) -> Array[NewCharacter]:
	var result: Array[NewCharacter] = []
	for c in character_list.get_children():
		var taken = false;
		for a in already_loaded:
			if c.upgradeID == a.char_class:
				taken = true;
		if !taken:
			result.push_back(c as NewCharacter);
	
	return result
