extends Upgrade
class_name CharacterBuff


func type() -> String:
  return "buff"

func modify_attack(d:DamageInfo) -> DamageInfo:
  return d

func modify_hurt(d:DamageInfo) -> DamageInfo:
  return d