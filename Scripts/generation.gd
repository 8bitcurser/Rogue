extends Node

@onready var room_scene: PackedScene = load('res://Nodes/room.tscn')


var map_width: int = 7
var map_height: int = 7

var rooms_to_generate: int = 12
var room_count: int = 0
var rooms_instantiated: int 
var first_room_pos: Vector2

var map: Array
var room_nodes: Array

# Spawn Chance
@export var enemy_spawn_chance: float
@export var coins_spawn_chance: float
@export var heart_spawn_chance: float

@export var max_enemy_per_room: int
@export var max_hearts_per_room: int
@export var max_coins_per_room: int


func _ready() -> void:
	for i in range(map_width):
		map.append([])
		for j in range(map_height):
			map[i].append(false)
	seed(375892334)
	generate()
	# center the player inside the main room
	$"../Player".global_position = (first_room_pos * 816) + Vector2(262, 262)


func generate() -> void:
	check_room(3, 3, 0, Vector2.ZERO, true)
	instantiate_room()

func check_room(x: int, y: int, remaining: int, general_direction: Vector2, first_room: bool = false) -> void:
	if room_count >= rooms_to_generate:
		# we already created all the rooms needed
		return

	if x < 0 or x > map_width -1 or y < 0 or y > map_height -1:
		# avoids going out of bound
		return

	if first_room == false and remaining <= 0:
		# no more rooms to be created
		return
		
	if map[x][y] == true:
		# room already created
		return 
	
	if first_room:
		first_room_pos = Vector2(x, y)

	room_count += 1
	map[x][y] = true
	
	# sets the probability of having a north wall, if the the direction is up
	# makes sense to have more chances of having a wall up north than if 
	# the general direction is for example to the east
	var north: bool = randf() > (0.2 if general_direction == Vector2.UP else 0.8)
	var south: bool = randf() > (0.2 if general_direction == Vector2.DOWN else 0.8)
	var east: bool = randf() > (0.2 if general_direction == Vector2.RIGHT else 0.8)
	var west: bool = randf() > (0.2 if general_direction == Vector2.LEFT else 0.8)
	
	var max_remaining: int = rooms_to_generate / 4
	var rem: int = max_remaining if first_room else remaining - 1

	var dir_up: Vector2 = Vector2.UP if first_room else general_direction
	var dir_down: Vector2 = Vector2.DOWN if first_room else general_direction
	var dir_left: Vector2 = Vector2.LEFT if first_room else general_direction
	var dir_right: Vector2 = Vector2.RIGHT if first_room else general_direction

	if north or first_room:
		check_room(x, y + 1, rem, dir_up)
	if south or first_room:
		check_room(x, y - 1, rem, dir_down)
	if east or first_room:
		check_room(x+1, y, rem, dir_right)
	if west or first_room:
		check_room(x-1, y, rem, dir_left)
	
func instantiate_room() -> void:
	if rooms_instantiated:
		return
	rooms_instantiated = true
	for x in range(map_width):
		for y in range(map_height):
			if map[x][y] == false:
				continue
			var room = room_scene.instantiate()
			# 17 * 48 (size of tile) = 816
			# (16 is the amount of tiles from left to right but we add 1 more 
			# to avoid overlapp )
			
			room.position = Vector2(x, y) * (16*48)
			# we check the if the room under exists if it exists
			if y > 0 and map[x][y - 1] == true:
				room.north()
			# if room on top exists we want to make a pathway to the south
			if y < map_height and map[x][y + 1] == true:
				room.south()

			if x > 0 and map[x - 1][y] == true:
				room.west()

			if x < map_width and map[x + 1][y] == true:
				room.east()

			if(first_room_pos != Vector2(x, y)):
				room.Generation = self
			# call parent node
			$"..".call_deferred("add_child", room)
			room_nodes.append(room)

	get_tree().create_timer(1)
	calculate_key_and_exit()

func calculate_key_and_exit() -> void:
	pass
