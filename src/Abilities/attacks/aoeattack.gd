extends Attack

func attack(_t:Node2D, attack_mod:float = 1.0, _level:float = 1.0):
	var dmg = DamageInfo.new();
	
	dmg.damage = (damage + _level * damagePerLevel) * attack_mod;
	dmg.type = type;
	for target in get_tree().get_nodes_in_group("allies"):
		target.take_damage(dmg)
		if hitAnimation:
			var playhit = hitAnimation.instantiate() as AnimatedSprite2D;
			add_child(playhit)
			playhit.global_position = target.hitPos.global_position;
			playhit.play();
			await playhit.animation_finished;
			playhit.queue_free();
