extends Node

@export var enemySpawns:Array[Marker2D]
@export var alliesSpawns:Array[Marker2D]
@export var enemyListNode:Node;
@export var heroClassListNode:Node;
@export var spawnNode:Node;

func _ready():
	GameState.enemySpawns = enemySpawns
	GameState.alliesSpawns = alliesSpawns
	GameState.enemyListNode = enemyListNode
	GameState.heroClassListNode = heroClassListNode
	GameState.spawnNode = spawnNode
