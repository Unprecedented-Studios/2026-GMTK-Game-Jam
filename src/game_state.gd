extends Node
@onready var enemies:Node2D = get_node("../Enemies")
var enemyList:Array[PackedScene];
@onready var enemyListNode:Node = get_node("../EnemiesList");
func _ready():
	enemyList = enemyListNode.enemys;

func _on_enemies_child_exiting_tree(node):
	if enemies.get_child_count() == 1:
		#last enemy died
		
		#select upgrade
		
		#spawn next enemy
		call_deferred("spawn_next_enemy");
		
func spawn_next_enemy():
		var enemyScene = enemyList.pick_random() as PackedScene;
		if not enemyScene:
			push_error("No enemies to spawn!")
			
		var newEnemy = enemyScene.instantiate() as Character;
		
		enemies.add_child(newEnemy);
		newEnemy.show();
		
