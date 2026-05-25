extends Node3D

func _on_door_trigger_body_entered(body):
	if body is CharacterBody3D:
		print("ACTIVATED!")
		get_tree().change_scene_to_file("res://scenes/hallway1.tscn")
