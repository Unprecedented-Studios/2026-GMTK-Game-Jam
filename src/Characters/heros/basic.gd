extends Character
class_name basicHero

func _process(_delta: float) -> void:
	var enemies:Array = get_tree().get_nodes_in_group("enemies");
	if enemies.size() > 0:
		var e = enemies.pick_random();
		e.take_damage(DamageInfo.new())
