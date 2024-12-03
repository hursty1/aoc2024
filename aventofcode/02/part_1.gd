extends Node3D

#const DAY_2 = preload("res://02/day2.txt")
@export var dooda:PackedScene
var res
func _ready() -> void:
	res = GameSettings.load_from_file("res://02/day2.txt")
	var num_safe = 0
	var row_num = 1
	for line in res:
		#cnt += 2
		if line == "":
			continue
		var l = line.split(',')
		num_safe += test_row(line, row_num)
		row_num += 1
	print(num_safe)

func test_row(row, index):
	var items = row.split(',')
	var row_list = []
	var safe = false
	var safe_2 = false
	for item in items:
		row_list.append(int(item))
		#print(row_list)
	#Condition 1
	var increasing = is_increasing(row_list)
	var decreasing = is_decreasing(row_list)
	
	if increasing or decreasing:
		safe = true
	#else:
		
		#return 0
		
	## Condition 2
	var condition_2 = condition_2(row_list)
	if condition_2:
		safe_2 = true
	#else:
		#return 0
	spawn_row(row_list, index,safe,safe_2)
	if safe and safe_2:
		return 1
	else:
		return 0
	
	
func is_increasing(row_list: Array) -> bool:
	for i in range(len(row_list) - 1):
		if row_list[i] >= row_list[i + 1]:
			return false
	return true
	
func is_decreasing(row_list: Array) -> bool:
	for i in range(len(row_list) - 1):
		if row_list[i] <= row_list[i + 1]:
			return false
	return true

func condition_2(row_list) -> bool:
	for i in range(len(row_list) - 1):
		if abs(row_list[i] - row_list[i + 1]) > 3:
			return false
	return true
	
	
func spawn_row(row_list, row_num:int, con_1, con_2:bool):
	for i in range(len(row_list)):
		# load box
		var item = row_list[i]
		#print("%s %s %s", [i, item, row_num])
		load_box(i,item,row_num,con_1,con_2)
	
#x, y, z
#z is row
#x is item in row
#y is value
	
func load_box(x,y,z, con_1:bool, con_2:bool):
	var n = dooda.instantiate()
	add_child(n)
	n.global_position = Vector3(x, y, -z)
	n.set_text("%s | %s" % [con_1, con_2])
	#print("Setting height for box at (%s, %s, %s): %s" % [x, z, y, y])
	#n.box.mesh.size.y = y
	#n.set_height(z)
