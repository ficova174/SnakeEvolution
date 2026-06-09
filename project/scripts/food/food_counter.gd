class_name FoodCounter
extends Resource


var max_food_mass: int = 100
var food_mass: int = 0


func setMaxFoodMass(mass: int) -> void:
	if mass < 0:
		push_error("Negative max food mass forbidden")
		return
	max_food_mass = mass

func increment(mass: int) -> void:
	food_mass += mass

func decrement(mass: int) -> void:
	food_mass -= mass
	if food_mass < 0:
		push_error("Negative food mass forbidden")
		return
