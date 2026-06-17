class_name AgentCounter
extends Resource


@export var max_agents: int = 200


func setMaxAgents(number: int) -> void:
	if number < 0:
		push_error("Negative max number of agents forbidden")
		return
	max_agents = number
