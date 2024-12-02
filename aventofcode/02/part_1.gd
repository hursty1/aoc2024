extends Node3D

#const DAY_2 = preload("res://02/day2.txt")
var res
func _ready() -> void:
	res = GameSettings.load_from_file("res://02/day2.txt")
	var num_safe = 0
	for line in res:
		#cnt += 2
		if line == "":
			continue
		var l = line.split(',')
		num_safe += test_row(line)
	print(num_safe)

func test_row(row):
	var items = row.split(' ')
	var row_list = []
	var safe = false
	for item in items:
		row_list.append(int(item))
		#print(row_list)
		safe = is_monotonic(row_list)
		if safe:
			print(safe)
			return 1
	return 0
	
func is_monotonic(row_list):
	var increasing = true
	var decreasing = true
	for i in range(len(row_list) - 1):
		print(row_list[i])
		print(row_list[i+1])
		if row_list[i] < row_list[i + 1]:
			decreasing = false
		elif row_list[i] > row_list[i + 1]:
			increasing = false
		else:
			increasing = false
			decreasing = false
	return increasing or decreasing
	
func spawn_row(row):
	pass
