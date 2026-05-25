extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("Books touched, hiding object")
		# Get the parent (the Books mesh) and hide it
		get_parent().visible = false
