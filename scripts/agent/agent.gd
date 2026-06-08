class_name Agent
extends Snake

signal mass_changed(new_mass: int)

@onready var ui: CanvasLayer = $CanvasLayer

func _ready() -> void:
	super()
	ui.hide()

func grow() -> void:
	super()
	mass_changed.emit(mass)

func follow_snake() -> void:
	super()
	ui.show()

func leave_snake() -> void:
	super()
	ui.hide()
