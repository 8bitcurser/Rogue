extends CharacterBody2D

const TILE_SIZE: int = 48

var has_key: bool = false

signal player_moved


func _physics_process(delta: float) -> void:
	player_input()


func player_input() -> void: 
	if Input.is_action_just_pressed('move_right'):
		velocity = Vector2.RIGHT
		move(velocity)
	elif Input.is_action_just_pressed('move_left'):
		velocity = Vector2.LEFT
		move(velocity)
	elif Input.is_action_just_pressed('move_up'):
		velocity = Vector2.UP
		move(velocity)
	elif Input.is_action_just_pressed('move_down'):
		velocity = Vector2.DOWN
		move(velocity)
		
	if Input.is_action_just_pressed('attack_right'):
		velocity = Vector2.RIGHT
		try_attack(velocity)
	if Input.is_action_just_pressed('attack_left'):
		velocity = Vector2.LEFT
		try_attack(velocity)
	if Input.is_action_just_pressed('attack_up'):
		velocity = Vector2.UP
		try_attack(velocity)
	if Input.is_action_just_pressed('attack_down'):
		velocity = Vector2.DOWN
		try_attack(velocity)


func move(direction: Vector2) -> void:
	'''
		We determine if we can move or not in the direction we want, if we collide
		against a wall then we stay put. 
		1. We obtain the world grid
		2. We obtain the point from which we want to move
		3. We calculate the offset, end point of the ray (48 cause the original tiles are 16 * 16)
		but we scaled everything by 3
		4. We determine if the ray collides against something in the grid in that direction
		player 
	'''
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var ray_offset = global_position + Vector2(TILE_SIZE, TILE_SIZE) * direction
	var query = PhysicsRayQueryParameters2D.create(global_position, ray_offset)
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider.is_in_group("Wall") or result.collider.is_in_group("Enemy"):
			return
	
	position += TILE_SIZE * direction
	player_moved.emit()
	$SFX.stream = load("res://Assets/SFX/walk.wav")
	$SFX.play()

func try_attack(direction: Vector2) -> void:
	var space_rid = get_world_2d().space
	var space_state = PhysicsServer2D.space_get_direct_state(space_rid)
	var ray_offset = global_position + Vector2(TILE_SIZE, TILE_SIZE) * direction
	var query = PhysicsRayQueryParameters2D.create(global_position, ray_offset)
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider.is_in_group("Enemy"):
			result.collider.take_damage(1)

func take_damage(damage_taken: int) -> void:
	Global.health -= damage_taken
	if Global.health <= 0:
		Sfx.get_child(4).play()
		get_tree().reload_current_scene()
	$AnimationPlayer.play('hit')
	$SFX.stream = load("res://Assets/SFX/Hit.wav")
	$SFX.volume_db = -20
	$SFX.play()
