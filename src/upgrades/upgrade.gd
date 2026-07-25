extends Node
class_name Upgrade

@export var info: String = "Simple Heal - small heal with short cooldown"
@export var icon: Sprite2D;
@export var upgradeID:String;

func type() -> String:
  return "basic"

func apply_to_character(_c:Character):
  pass