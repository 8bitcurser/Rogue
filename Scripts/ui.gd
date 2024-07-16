extends CanvasLayer

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group('Player')
@onready var generation: Node = $"../Generation"
@onready var grid: PackedScene = load("res://Scenes/minimap_grid.tscn")


func _ready():
	generate_minimap()


func _process(delta):
	$StatBar/coins.text = str(Global.coins)
	if player.has_key: 
		$StatBar/KeySprite.modulate = "ffffff"
	match Global.health:
		8:
			$HealthBar/Heart1.frame = 2
			$HealthBar/Heart2.frame = 2
			$HealthBar/Heart3.frame = 2
			$HealthBar/Heart4.frame = 2
		7:
			$HealthBar/Heart1.frame = 1
			$HealthBar/Heart2.frame = 2
			$HealthBar/Heart3.frame = 2
			$HealthBar/Heart4.frame = 2
		6:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 2
			$HealthBar/Heart3.frame = 2
			$HealthBar/Heart4.frame = 2
		5:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 1
			$HealthBar/Heart3.frame = 2
			$HealthBar/Heart4.frame = 2
		4:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 0
			$HealthBar/Heart3.frame = 2
			$HealthBar/Heart4.frame = 2
		3:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 0
			$HealthBar/Heart3.frame = 1
			$HealthBar/Heart4.frame = 2
		2:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 0
			$HealthBar/Heart3.frame = 0
			$HealthBar/Heart4.frame = 2
		1:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 0
			$HealthBar/Heart3.frame = 0
			$HealthBar/Heart4.frame = 1
		0:
			$HealthBar/Heart1.frame = 0
			$HealthBar/Heart2.frame = 0
			$HealthBar/Heart3.frame = 0
			$HealthBar/Heart4.frame = 0
	
	$Minimap/Level.text = "Level " + str(Global.level)
	
	update_minimap()


func generate_minimap() -> void:
	$Minimap/GridContainer.columns = generation.map_width
	for i in range(generation.map_height):
		for j in range(generation.map_width):
			var panel = grid.instantiate()
			if generation.map[j][i] == false:
				# make panel transparent if not set
				panel.modulate = "ffffff00"
			else:
				panel.is_room = true
			panel.pos = Vector2i(j, i)
			$Minimap/GridContainer.add_child(panel)

func update_minimap() -> void:
	var pos: Vector2i = (player.global_position / 816)
	var panels = $Minimap/GridContainer.get_children()
	for panel in panels:
		if panel.is_room:
			panel.modulate = "ffffff"
			if panel.pos == pos:
				panel.modulate = "007a27"
	
