extends CharacterBody2D

var health: int = 3
var damage: int = 1

@onready var player = get_tree().get_nodes_in_group("Player")[0]
var attack_chance: float = 0.5

func _ready():
	add_to_group("Enemy")

func move() -> void:
	if randf() < 0.5:
		return
	var direction: Vector2 = Vector2.ZERO
	var can_move: bool = false

	while (can_move == false):
		direction = get_random_direction()
		var space_rid = get_world_2d().space
		var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
		var ray_offset = global_position + Vector2(48, 48) * direction
		var query = PhysicsRayQueryParameters2D.create(global_position, ray_offset)
		var result = space_state.intersect_ray(query)
		
		if result:
			var collisions: Array = [
				result.collider.is_in_group("Wall"),
				result.collider.is_in_group("Player")
			]
			if true in collisions:
				continue
		
		# we are not colliding with the raycast
		# and check if the position we are going to move is not the position
		# of the player (we avoid overlapping)
		var movement: Vector2 = position + 48 * direction 
		if not result and movement != player.position:
			can_move = true
		position = movement

func get_random_direction() -> Vector2:
	var ran: int = randi_range(0, 3)
	match ran:
		0:
			return Vector2.UP
		1:
			return Vector2.DOWN
		2:
			return Vector2.RIGHT
		3:
			return Vector2.LEFT
	return Vector2.ZERO


func take_damage(damage_taken: int) -> void:
	health -= damage_taken

	if health <= 0:
		queue_free()
	$AnimationPlayer.play('hit')
	if randf() > attack_chance:
		player.take_damage(damage)
	$SFX.stream = load("res://Assets/SFX/Hit.wav")
	$SFX.play()
