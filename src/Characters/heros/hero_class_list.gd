extends Node

@export var classes:Array[PackedScene]

var maleHeroNames = [
	'Alan',
	'Bob',
	'Carl',
	'Dan',
	'Evan'
	]
var availibleNames:Array[String] = [];

func resetNameList():
	for heroName:String in maleHeroNames:
		availibleNames.push_back(heroName)

func get_hero_name() -> String:
	if availibleNames.size() == 0:
		resetNameList();
	var index = randi() % availibleNames.size()
		
	return availibleNames.pop_at(index)
