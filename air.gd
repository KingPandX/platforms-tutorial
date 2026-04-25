extends PlayerState


func physics_update(delta : float):
	if !character.is_on_floor():
		character.velocity.y += character.get_gravity().y * delta
	else:
		change_state("idle")
	
	character.move_and_slide()
