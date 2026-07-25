extends Node

@onready var character_list = get_node("characters")

func get_new_allies() -> Array[NewCharacter]:
	var result: Array[NewCharacter] = []
	for c in character_list.get_children():
		result.push_back(c as NewCharacter);
	
	return result
