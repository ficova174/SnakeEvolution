extends CharacterBody2D


var min_speed: float
var max_speed: float
var acceleration: float
var speed: float


func _ready() -> void:
	speed = min_speed

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("dash"):
		speed = move_toward(speed, max_speed, acceleration * delta)
	else:
		speed = move_toward(speed, min_speed, acceleration * delta)

	velocity = transform.x * speed
	move_and_slide()
