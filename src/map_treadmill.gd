extends Node2D
signal walk_done

@onready var maps:Array[TileMapLayer] = [$Map, $Map2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shift_map():
	if int(round($Map.position.x)) <= -2560:
		$Map.position.x = $Map2.position.x + 2560
	if int(round($Map2.position.x)) <= -2560:
		$Map2.position.x = $Map.position.x + 2560

	for map:TileMapLayer in maps:
		var tween = get_tree().create_tween()
		tween.tween_property(map,"position",Vector2(map.position.x -512.0,0),2.0)
		await tween.finished
		walk_done.emit();
