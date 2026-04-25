extends FSMState
class_name PlayerState

var character : Player
var visual : AnimatedSprite2D

func enter_state(data : Dictionary = {}):
	pass

func process_update(delta : float):
	pass

func physics_update(delta : float):
	pass

func exit_state():
	pass

func setup(context : Array[Node]):
	character = context[0]
	visual = context[1]
