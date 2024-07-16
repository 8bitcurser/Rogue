extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.health += 1
		Sfx.get_child(1).play()
		queue_free()
 
