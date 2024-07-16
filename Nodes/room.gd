extends Node2D

@export var inside_width: int
@export var inside_height: int
@export var enemy_node: PackedScene
@export var coin_node: PackedScene 
@export var heart_node: PackedScene
@export var key_node: PackedScene
@export var exit_node: PackedScene

# this is a really cool thing
# we pass the Generation node to the Generation when creating the room
# which gives us access to the variables used to generate the rooms
@onready var Generation: Node
@onready var enemies: Node = $Enemies


var used_positions: Array

func _ready():
	if Generation:
		generate_interior()

func north():
	$NorthDoor.visible = true
	$NorthWall.queue_free()

func south():
	$SouthDoor.visible = true
	$SouthWall.queue_free()

func east():
	$EastDoor.visible = true
	$EastWall.queue_free()

func west():
	$WestDoor.visible = true
	$WestWall.queue_free()

func generate_interior() -> void:
	if randf_range(0,1) < Generation.enemy_spawn_chance:
		spawn_node(enemy_node, 1, Generation.max_enemies_per_room)

	if randf_range(0,1) < Generation.coin_spawn_chance:
		spawn_node(coin_node, 1, Generation.max_coins_per_room)

	if randf_range(0,1) < Generation.heart_spawn_chance:
		spawn_node(heart_node, 1, Generation.max_hearts_per_room)


func spawn_node(node_scene: PackedScene, min_ins: int = 0, max_ins: int = 0) -> void:
	var num: int = 1
	if min_ins != 0 or max_ins != 0:
		num = randi_range(min_ins, max_ins)

	for i in range(num):
		var node_object = node_scene.instantiate()
		# 3 because if not it can spawn inside the wall
		# inside_width/height is the max size of the room - 3 for the same reason
		# -24 cause the tiles are 48px width by substracting 24 the node is
		# in the middle
		var pos: Vector2 = Vector2(
			48 * randi_range(3, inside_width - 3) - 24,
			48 * randi_range(3, inside_height - 3) - 24
		)
		while pos in used_positions:
			pos = Vector2(
				48 * randi_range(3, inside_width - 3) - 24,
				48 * randi_range(3, inside_height - 3) - 24
			)
		node_object.position = pos
		used_positions.append(pos)
		add_child(node_object)

	if node_scene == enemy_node:
		get_tree().get_first_node_in_group('Enemy_Manager').check_enemies()
