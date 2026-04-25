@abstract
extends Node
class_name FSMState

@abstract func enter_state(data : Dictionary = {})

@abstract func process_update(delta : float)

@abstract func physics_update(delta : float)

@abstract func exit_state()

func change_state(route : String, data : Dictionary = {}):
	get_parent().change_state(route, data)

@abstract func setup(context : Array[Node])
