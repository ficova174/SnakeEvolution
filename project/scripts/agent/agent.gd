class_name Agent
extends Snake


signal mass_changed(new_mass: int)

@onready var vision: Node2D = $Head/VisionComponent
@onready var ui: CanvasLayer = $CanvasLayer

var score: float
var birth_time: int

var mutated_brain: Brain


func _ready() -> void:
	super()

	vision.add_vision_exception(head)
	vision.add_vision_exception(body_segments[0])

	if mutated_brain != null:
		head.brain = mutated_brain
	birth_time = Time.get_ticks_msec()
	ui.hide()

func _physics_process(_delta: float) -> void:
	super(_delta)
	score = mass ** 5 * (Time.get_ticks_msec() - birth_time) / 1000.0

func grow() -> void:
	var before_size: int = body_segments.size()
	super()
	for i in range(before_size, body_segments.size()):
		vision.add_vision_exception(body_segments[i])
	mass_changed.emit(mass)

func follow_snake() -> void:
	super()
	ui.show()

func leave_snake() -> void:
	super()
	ui.hide()
