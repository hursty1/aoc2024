extends Node3D


@export var weapon_1: Node3D
@export var weapon_2: Node3D


func _ready():
	equip(weapon_1)
	
func _unhandled_input(_event):
	if Input.is_action_just_pressed(GameSettings.WEAPON_1):
		equip(weapon_1)
	if Input.is_action_just_pressed(GameSettings.WEAPON_2):
		equip(weapon_2)
	if Input.is_action_pressed(GameSettings.WEAPON_NEXT):
		nextWeapon(false)
	if Input.is_action_pressed(GameSettings.WEAPON_PREV):
		nextWeapon(true)
func equip(active_weapon:Node3D) -> void:
	for child in get_children():
		if child == active_weapon:
			child.visible = true
			child.set_process(true)
			#child.ammo_handler.update_ammo_label(child.ammo_type)
		else:
			child.visible = false
			child.set_process(false)


func nextWeapon(prev:bool)-> void:
	var index = get_current_index()
	if prev:
		index = wrapi(index -1, 0, get_child_count())
	else:
		index = wrapi(index +1, 0, get_child_count())
	equip(get_child(index))
	
func get_current_index() -> int:
	for index in get_child_count():
		if get_child(index).visible:
			return index
	return 0
	
