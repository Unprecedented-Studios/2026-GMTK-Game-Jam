extends Node
class_name Attack

@export var damage: float = 1;
@export var type: DamageInfo.damage_types = DamageInfo.damage_types.NORMAL;
@export var hitAnimation:PackedScene;
@export var animationName:String;

func attack(target:Node2D):
	
	var dmg = DamageInfo.new();
	dmg.damage = damage;
	dmg.type = type;
	if target:
		target.take_damage(dmg)
		if hitAnimation:
			var playhit = hitAnimation.instantiate() as AnimatedSprite2D;
			add_child(playhit)
			playhit.global_position = target.hitPos.global_position;
			playhit.play();
			await playhit.animation_finished;
			playhit.queue_free();
