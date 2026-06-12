class_name Agent
extends Snake


signal mass_changed(new_mass: int)

@onready var ui: CanvasLayer = $CanvasLayer

var score: float
var birth_time: int


func _ready() -> void:
	super()
	birth_time = Time.get_ticks_msec()
	ui.hide()

func _physics_process(_delta: float) -> void:
	super(_delta)
	score = (Time.get_ticks_msec() - birth_time) * mass / 1000.0

func grow() -> void:
	super()
	mass_changed.emit(mass)

func follow_snake() -> void:
	super()
	ui.show()

func leave_snake() -> void:
	super()
	ui.hide()
