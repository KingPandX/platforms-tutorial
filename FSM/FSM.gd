extends Node
class_name FSM

@export var init_state : FSMState
var current_state : FSMState
@export var context : Array[Node]

func _ready() -> void:
	for chil in get_children():
		if chil is FSMState:
			chil.setup(context)
	
	current_state = init_state
	current_state.enter_state()

func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func _process(delta: float) -> void:
	print(current_state.name)
	current_state.process_update(delta)

func change_state(route : String, data : Dictionary = {}):
	var next_state = find_child(route)
	if !next_state is FSMState:
		push_error("El nodo en la ruta no es un estado valido")
		return
	
	if current_state:
		current_state.exit_state()
	current_state = next_state
	current_state.enter_state(data)
