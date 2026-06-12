extends Resource

var score_array: Array[float]
var agent_array: Array[Agent]

func add_agent(agent: Agent) -> void:
	if score_array.is_empty():
		score_array.append(agent.score)
		agent_array.append(agent)
		return
	for i in range(score_array.size()):
		if agent.score > score_array[i]:
			score_array.insert(i, agent.score)
			agent_array.insert(i, agent)
			return
	score_array.append(agent.score)
	agent_array.append(agent)

func remove_agent(agent: Agent) -> void:
	for i in range(agent_array.size()):
		if agent_array[i] == agent:
			score_array.remove_at(i)
			agent_array.remove_at(i)

func _physics_process(delta: float) -> void:
	update()
	sort()

func update() -> void:
	if agent_array.size() <= 1:
		return
	for i in range(agent_array.size()):
		score_array.set(i, agent_array[i].score)

func sort() -> void:
	if agent_array.size() <= 1:
		return
	for i in range(1, agent_array.size()):
		for j in range(1, i):
			if score_array[i-j] >= score_array[i]:
				var score_value: float = score_array.pop_at(i)
				var agent: Agent = agent_array.pop_at(i)
				score_array.insert(i-j+1, score_value)
				agent_array.insert(i-j+1, agent)
