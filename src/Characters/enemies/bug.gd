extends Character

func _attack() -> void:
	var allies:Array = get_tree().get_nodes_in_group("allies");
	if allies.size() > 0:
		target = allies.pick_random();
		animation.play("bite");
		animation.queue("idle");
