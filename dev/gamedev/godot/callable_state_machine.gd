extends Node

# from https://www.youtube.com/watch?v=30aPLDeN2kk&ab_channel=FirebelleyGames around 30:30
# use this class:
# seems to be a alternative to using an Animation State Machine and handle things more manually

class_name CallableStateMachine

var state_dictionary = {}
var current_state: String


func add_states(
	normal_state_callable: Callable,
	enter_state_callable: Callable,
	leave_state_callable: Callable
):
	state_dictionary[normal_state_callable.get_method()] = {
		"normal": normal_state_callable,
		"enter": enter_state_callable,
		"leave": leave_state_callable
	}


func set_initial_state(state_callable: Callable):
	var state_name = state_callable.get_method()
	if state_dictionary.has(state_name):
		_set_state(state_name)
	else:
		push_warning("No state with name " + state_name)


func update():
	if current_state != null:
		(state_dictionary[current_state].normal as Callable).call()


func change_state(state_callable: Callable):
	var state_name = state_callable.get_method()
	if state_dictionary.has(state_name):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state with name " + state_name)


func _set_state(state_name: String):
	if current_state:
		var leave_callable = state_dictionary[current_state].leave as Callable
		if !leave_callable.is_null():
			leave_callable.call()
	
	current_state = state_name
	var enter_callable = state_dictionary[current_state].enter as Callable
	if !enter_callable.is_null():
		enter_callable.call()

rough usage:

var state_machine: CallableStateMachine = CallableStateMachine.new();

func _ready():
  state_machine.add_states();
  # NOTE: normal state (first arg) is called every .update()
  # enter (second arg) is called once when entering a state
  # leave (third arg) is called once when leaving a state before entering a diff state
  state_machine(state_normal, Callable(), Callable());
  state_machine(state_spawn, enter_state_spawn, Callable());
  state_machine(state_dash, enter_state_dash, leave_state_dash);

func _physics_process(delta):
  # the state_machine would handle setting velocity
  state_machine.update();
  move_and_slide();
  
