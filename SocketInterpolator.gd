class_name SocketInterpolator extends Node

@export var target : Node3D
@export var batch : Array[SocketData]
@export var autostart := false

func _ready():
	Start()

func Start() -> void:
	if not target:
		return
	
	var t = target.create_tween() as Tween
	
	for i in range(batch.size()):
		var indexBatch = batch[i]
		
		var x = Transform3D(Basis(Quaternion.from_euler(indexBatch.rot)), indexBatch.pos) as Transform3D
		x = x.scaled(indexBatch.scale)
		
		t.tween_property(target, "global_transform", x, indexBatch.dur)
	
	t.set_ease(Tween.EASE_IN_OUT)
	t.play()
