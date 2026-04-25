extends PlayerState

func enter_state(data : Dictionary = {}):
	visual.play("Idle")

func physics_update(delta : float):
	var Xaxis = Input.get_axis("left","right")
	
	if Xaxis != 0:
		change_state("move")
	
	if Input.is_action_just_pressed("jump"):
		character.JumpBuffer = true
		character.buffer_timer.start()
	
	if character.can_jump and character.JumpBuffer:
		change_state("jump")
	
	if !character.is_on_floor():
		change_state("air")
	
	character.move_and_slide()
