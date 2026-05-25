extends Node3D
var can_trigger = true
func _on_area_3d_body_entered(body: Node3D) -> void:
	if not can_trigger or not body is CharacterBody3D:
		return
	can_trigger = false
	print("DES")
	call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://scenes/PO.tscn")
