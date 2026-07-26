extends Character

func _attack() -> void:
	if current_hp == 0:
		return #return cause you can't attack someone when you're dead...
	var allies:Array = get_tree().get_nodes_in_group("allies");
	if allies.size() > 0:
		target = allies.pick_random();
		animation.play("bite");
		animation.queue("idle");
