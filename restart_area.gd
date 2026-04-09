extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _restart():
	get_tree().reload_current_scene()


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player": return
	_restart()
