extends Node3D

@export var nodey:PackedScene

func _ready():
	var res = load_from_file()
	var left:Array = []
	var right:Array = []
	var cnt = 0
	for line in res:
		#cnt += 2
		if line == "":
			continue
		var l = line.split(',')
		
		left.append(l[0])
		right.append(l[1])
		
	left.sort()
	right.sort()
	var running_total = 0
	for i in range(len(left)):
		running_total += int(left[i]) + int(right[i])
		load_box([left[i], right[i]], i)
	print(running_total)
	answer_box(running_total)
	
	
func answer_box(answer):
	var n = nodey.instantiate()
	add_child(n)
	n.global_position = Vector3(3, 0.25, 3)
	n.set_text("Answer is: %s" % answer)
func load_box(l, cnt):
	var n = nodey.instantiate()
	add_child(n)
	n.global_position = Vector3(-2, 0.25, -cnt)
	n.set_text("%s + %s" % [l[0], l[1]])
func load_from_file():
	var file = FileAccess.open("res://01/data2.txt", FileAccess.READ)
	if file: # Check if the file was opened successfully
		var content = file.get_as_text()
		file.close()
		return content.split("\n") # Splits the text into an array of lines
	else:
		print("Failed to open file.")
		return []
