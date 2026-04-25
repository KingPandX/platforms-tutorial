extends PlayerState

func physics_update(delta : float):
	var Xaxis = Input.get_axis("left","right")
	
	var target_speed = Xaxis * character.MaxSpeed
	if Xaxis != 0:
		visual.flip_h = Xaxis < 0
		character.velocity.x = move_toward(character.velocity.x, target_speed, character.Acc)
	else:
		character.velocity.x = move_toward(character.velocity.x, target_speed, character.Dcc)
	
	if Input.is_action_just_pressed("jump"):
		character.JumpBuffer = true
		character.buffer_timer.start()
	
	if character.can_jump and character.JumpBuffer:
		change_state("jump")
	
	character.move_and_slide()
	
	if character.velocity.x == 0:
		change_state("idle")
	else:
		visual.play("Run")
