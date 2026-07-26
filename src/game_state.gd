extends Node
signal game_over;

var enemySpawns:Array[Marker2D]
var alliesSpawns:Array[Marker2D]
var enemyListNode:Node;
var heroClassListNode:Node;
var spawnNode:Node;

var enemyList:Array[PackedScene];
var no_more_upgrades: bool = false

var active_allies: Array[Character]=[];
var active_enemies: Array[Character]=[];
var all_characters:Array[Character]:
	get:
		return active_allies + active_enemies;
		
var player_level = 1;

signal enemy_died
func _on_enemy_died():
	for enemy in active_enemies:
		if enemy and !enemy.is_alive:
			enemy.queue_free();
			active_enemies.erase(enemy)
			
	if active_enemies.size() == 0:
		#last enemy died
		
		#select upgrade
		enemy_died.emit()

signal select_character(Character)

func _on_character_selected(c:Character):
	for character in all_characters:
		character.selected = false;
	c.selected = true;
	select_character.emit(c)

func spawn_next_enemy():
	if !enemyList:	
		enemyList = enemyListNode.enemys;
	var enemyScene = enemyList.pick_random() as PackedScene;
	if not enemyScene:
		push_error("No enemies to spawn!")
		
	var newEnemy = enemyScene.instantiate() as Character;
	active_enemies.push_back(newEnemy);
	spawnNode.add_child(newEnemy);
	var spawn_point = enemySpawns.pick_random();
	newEnemy.set_level(player_level);
	newEnemy.global_position = spawn_point.global_position;
	newEnemy.died.connect(_on_enemy_died)
#	newEnemy.clicked_on.connect(_on_character_selected)
	if (player_level == 1):
		newEnemy.walk();
	var tween = get_tree().create_tween()
	tween.tween_property(newEnemy,"position",Vector2(newEnemy.position.x-512,newEnemy.position.y),2)
	newEnemy.can_attack = false;
	await tween.finished
	newEnemy.can_attack = true;
	newEnemy.stop();

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
	no_more_upgrades = false
	for child_enemy:Character in active_enemies:
		child_enemy.queue_free();
	for child_ally:Character in active_allies:
		child_ally.queue_free();
		
	active_enemies = [];
	active_allies = [];
	player_level = 1;
	spawn_next_enemy()
	var heroNode = heroClassListNode.classes[0] as PackedScene;
	spawn_hero(heroNode, "base")

func spawn_hero(heroNode:PackedScene, _upgradeID: String):
	var hero = heroNode.instantiate() as Character;
	var spawn_point:Marker2D = null
	for spoint in alliesSpawns:
		if !spawn_point:
			if -1 == active_allies.find_custom( func(a): 
				return a.global_position == spoint.global_position
				):
				spawn_point = spoint
			
	active_allies.push_back(hero);
	hero.char_class = _upgradeID;
	spawnNode.add_child(hero)
	hero.global_position = spawn_point.global_position;
	hero.died.connect(_on_ally_died)
	hero.clicked_on.connect(_on_character_selected)
	hero.show();

func allow_attacks(value:bool):
	for character in all_characters:
		character.can_attack = value;

func increase_player_level():
	player_level += 1;
	active_allies.map(func(a:Character): a.set_level(player_level))
