extends Character
class_name basicHero

@export var damage: float = 1;
@export var type: DamageInfo.damage_types = DamageInfo.damage_types.NORMAL;

func _attack() -> void:
	if current_hp == 0:
		return #return cause you can't attack someone when you're dead...
	var enemies:Array = get_tree().get_nodes_in_group("enemies");
	if enemies.size() > 0:
		target = enemies.pick_random();
		animation.play("attack1");
		animation.queue("idle");
