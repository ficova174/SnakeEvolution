class_name Genome
extends Resource


@export var acceleration: float = 300.0 # px/s^2
@export var min_speed: float = 300.0 # px/s
@export var max_speed: float = 600.0 # px/s
@export var rotation_speed: float = 6.0 # rad/s

func _init(acceleration_init: float = 300.0,
		   min_speed_init: float = 300.0,
		   max_speed_init: float = 600.0,
		   rotation_speed_init: float = 6.0
		   ) -> void:
	min_speed = min_speed_init
	max_speed = max_speed_init
	acceleration = acceleration_init
	rotation_speed = rotation_speed_init
