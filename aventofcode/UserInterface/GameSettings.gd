extends Node


const MOVE_LEFT = 'move_left'
const MOVE_RIGHT = 'move_right'
const MOVE_FORWARD = 'move_forward'
const MOVE_BACK = 'move_back'
const JUMP = 'jump'
const FIRE = 'left_click'
const WEAPON_1 = 'weapon_1'
const WEAPON_2 = 'weapon_2'
const WEAPON_NEXT = 'next_weapon'
const WEAPON_PREV = 'prev_weapon'
const WEAPON_AIM = 'scope'



func load_from_file(file_str):
	var file = FileAccess.open(file_str, FileAccess.READ)
	if file: # Check if the file was opened successfully
		var content = file.get_as_text()
		file.close()
		return content.split("\n") # Splits the text into an array of lines
	else:
		print("Failed to open file.")
		return []
