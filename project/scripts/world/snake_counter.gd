class_name SnakeCounter
extends Resource


var max_snakes: int = 10
var actual_snakes: int = 0


func setMaxSnakes(number: int) -> void:
	if number < 0:
		push_error("Negative max number of snakes forbidden")
		return
	max_snakes = number

func increment() -> void:
	actual_snakes += 1

func decrement() -> void:
	actual_snakes -= 1
	if actual_snakes < 0:
		push_error("Negative number of snakes forbidden")
		return
