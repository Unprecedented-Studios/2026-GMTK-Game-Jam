extends Character
class_name basicHero

@export var damage: float = 1;
@export var type: DamageInfo.damage_types = DamageInfo.damage_types.NORMAL;

func _choose_attack(_target:Character):
		animation.play("attack0");


func _attack() -> void:
	if current_hp == 0:
		return #return cause you can't attack someone when you're dead...
	var enemies:Array = get_tree().get_nodes_in_group("enemies");
	enemies = enemies.filter(_can_i_attack)
	if enemies.size() > 0:
		target = enemies.pick_random();
		_choose_attack(target)
		animation.queue("idle");
