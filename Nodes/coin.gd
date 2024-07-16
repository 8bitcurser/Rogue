extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		Global.coins += 1
		Sfx.get_child(0).play()
		queue_free()
