extends Node
signal game_over;

@export var enemySpawns:Array[Marker2D]
@export var alliesSpawns:Array[Marker2D]
@export var enemyListNode:Node;
@export var heroClassListNode:Node;

var enemyList:Array[PackedScene];

var active_allies: Array[Character]=[];
var active_enemies: Array[Character]=[];
var all_characters:Array[Character]:
	get:
		return active_allies + active_enemies;
		
var player_level = 0;

func _ready():
	enemyList = enemyListNode.enemys;


func _on_enemy_died():

	for enemy in active_enemies:
		if !enemy.is_alive:
			enemy.queue_free();
			active_enemies.erase(enemy)
			
	if active_enemies.size() == 0:
		#last enemy died
		
		#select upgrade
		
		#spawn next enemy
		spawn_next_enemy();
		
func spawn_next_enemy():
		player_level += 1;
		var enemyScene = enemyList.pick_random() as PackedScene;
		if not enemyScene:
			push_error("No enemies to spawn!")
			
		var newEnemy = enemyScene.instantiate() as Character;
		active_enemies.push_back(newEnemy);
		newEnemy.level = player_level;
		
		$"../SpawnLocations".add_child(newEnemy);
		var spawn_point = enemySpawns.pick_random();
		newEnemy.global_position = spawn_point.global_position;
		newEnemy.died.connect(_on_enemy_died)
		

func gameover():
	game_over.emit();

func _on_ally_died():
	var is_game_over = true;
	for ally:Character in active_allies:
		if (ally.is_alive):
			is_game_over = false
	if is_game_over:
		gameover();
		
func start_game():
	for child:Node in active_enemies:
		child.queue_free();
	for child:Node in active_allies:
		child.queue_free();
		
	active_allies = [];
	player_level = 0;
	spawn_next_enemy()
	var heroNode = heroClassListNode.classes[0] as PackedScene;
	spawn_hero(heroNode)

func spawn_hero(heroNode:PackedScene):
	var hero = heroNode.instantiate() as Character;
	var spawn_point = alliesSpawns[active_allies.size()];
	active_allies.push_back(hero);
	$"../SpawnLocations".add_child(hero)
	hero.global_position = spawn_point.global_position;
	hero.died.connect(_on_ally_died)
	hero.show();
	
	
