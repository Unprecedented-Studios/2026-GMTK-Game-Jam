extends Node
signal game_over;

@onready var enemies:Node2D = get_node("../Enemies")
@onready var allies:Node = get_node("../Allies");

var enemyList:Array[PackedScene];
@onready var enemyListNode:Node = get_node("../EnemiesList");

var player_level = 1;

func _ready():
	enemyList = enemyListNode.enemys;

func _on_enemies_child_exiting_tree(node):
	if enemies.get_child_count() == 1:
		#last enemy died
		
		#select upgrade
		
		#spawn next enemy
		call_deferred("spawn_next_enemy");
		
func spawn_next_enemy():
		player_level += 1;
		var enemyScene = enemyList.pick_random() as PackedScene;
		if not enemyScene:
			push_error("No enemies to spawn!")
			
		var newEnemy = enemyScene.instantiate() as Character;
		newEnemy.level = player_level;
		
		enemies.add_child(newEnemy);
		newEnemy.show();
		

func gameover():
	game_over.emit();

func _on_allies_child_entered_tree(node:Character):
	node.died.connect(_on_ally_died)

func _on_ally_died():
	var is_game_over = true;
	for ally:Character in allies.get_children():
		if (ally.is_alive):
			is_game_over = false
	if is_game_over:
		gameover();
