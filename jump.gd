extends PlayerState

func enter_state(data : Dictionary = {}):
	character.velocity.y += character.JumpForce
	change_state("air")
