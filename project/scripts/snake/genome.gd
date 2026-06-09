class_name Genome
extends Resource


@export var min_speed: float = 300.0 # px/s
@export var max_speed: float = 600.0 # px/s
@export var acceleration: float = 300.0 # px/s^2

func _init(min_speed_init: float = 300.0,
		   max_speed_init: float = 600.0,
		   acceleration_init: float = 300.0
		   ) -> void:
	min_speed = min_speed_init
	max_speed = max_speed_init
	acceleration = acceleration_init
