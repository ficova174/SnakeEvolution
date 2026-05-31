class_name Genome
extends Resource


var speed: float # px/s
var acceleration: float # px/s^2
var full_acc_duration: float # s
var rotation_speed: float # rad/s


func _init(speed_init: float = 300.0,
		   acceleration_init: float = 300.0,
		   full_acc_duration_init: float = 1.0,
		   rotation_speed_init: float = 45.0
		   ) -> void:
	speed = speed_init
	acceleration = acceleration_init
	full_acc_duration = full_acc_duration_init
	rotation_speed = rotation_speed_init
