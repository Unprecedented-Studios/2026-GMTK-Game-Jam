extends Character
class_name basicHero

@export var damage: float = 1;
@export var type: DamageInfo.damage_types = DamageInfo.damage_types.NORMAL;

func _attack() -> void:
	var enemies:Array = get_tree().get_nodes_in_group("enemies");
	if enemies.size() > 0:
		target = enemies.pick_random();
		animation.play("attack1");
		animation.queue("idle");
		
func attack_hit(id:int) -> void:
	if id == 1:
		var dmg = DamageInfo.new();
		dmg.damage = damage;
		dmg.type = type;
		if target:
			target.take_damage(dmg)
