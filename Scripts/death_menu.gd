extends Control

func _ready():
	$Intro/Buttons/Stats.text = "Level Reached: " + str(Global.level) + "\nEnemies defeated: " + str(Global.enemies_killed) +"\nCoins Collected: "+str(Global.coins) +"\n"

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") # Replace with function body.
