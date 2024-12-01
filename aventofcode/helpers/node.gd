extends Node3D



@onready var ll = $SubViewport/Label
#var ll
func _ready() -> void:
	#print('spawning')
	if ll == null:
		print("Label not found at path $SubViewport/Label")
	else:
		set_text("Hello, SubViewport!")

func set_text(text):
	ll.text = text
	pass
