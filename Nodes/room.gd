extends Node2D

@export var inside_width: int
@export var inside_height: int

var Generation

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
