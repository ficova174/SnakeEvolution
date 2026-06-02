class_name Genome
extends Resource


var min_speed: float # px/s
var max_speed: float # px/s
var acceleration: float # px/s^2
var rotation_speed: float # rad/s


func _init(min_speed_init: float = 300.0,
		   max_speed_init: float = 600.0,
		   acceleration_init: float = 300,
		   rotation_speed_init: float = 45.0
		   ) -> void:
	min_speed = min_speed_init
	max_speed = max_speed_init
	acceleration = acceleration_init
	rotation_speed = rotation_speed_init
