class_name TransformInterpolator extends Node

@export var from : Node3D : set = SetReset
@export var to : Node3D
@export var look_at_speed := 5.0
@export var reset_delay := 1.0

signal resetted
signal walked

var reset_transform: Transform3D

func SetReset(itemNode: Node3D) -> void:
	from = itemNode
	
	if not from:
		return
	
	await from.tree_entered
	reset_transform = from.transform

func _ready():
	pass

func WalkTo(direction = Vector3.FORWARD, duration = 1.5) -> void:
	if not from:
		return
	
	if not to:
		return
	
	if direction.length() < 1.0:
		printerr("direction.length == 0.0 is true : needs value != 0")
		return
	
	var t = from.create_tween() as Tween
	t.tween_property(from, "position", to.position - direction, duration)
	t.set_ease(Tween.EASE_IN_OUT)
	t.play()
	
	await t.finished
	walked.emit()

func Reset(interpolateTime := 0.5) -> void:
	if not from:
		return
	
	var x = from.transform.interpolate_with(reset_transform, reset_delay)
	var t = from.create_tween() as Tween
	t.tween_property(from, "transform", x, interpolateTime)
	t.set_ease(Tween.EASE_IN_OUT)
	t.play()
	
	await t.finished
	resetted.emit()

func _process(delta):
	if not from:
		return
	
	if not to:
		return
	
	var x = from.transform.looking_at(to.position)
	var y = from.transform.interpolate_with(x, look_at_speed * delta)
	from.transform = y
