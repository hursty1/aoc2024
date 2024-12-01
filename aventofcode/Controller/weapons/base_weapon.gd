extends Node3D
class_name BaseWeapon

@export_category("Assignments")
@export var weaponMesh : Node3D

@export_category("Weapon Stats")
@export var fireRate := 14.0
@export var recoil := 0.05
@export var recoil_return_rate := 10.0
@export var weapon_damage := 25.0
@export var damage_fall_off_curve: Curve

@export_category("Ammo Stats")
@export var clip_size: int = 30
@export var max_ammo: int = 30*5
@export var ammo_type := "Semi"

@onready var ray_cast = $RayCast3D
@onready var rof = $rof
@onready var weapon_position : Vector3 = weaponMesh.position

## Animation
@export_category("Animations")
@export var muzzleFlash: GPUParticles3D
@export var hitFlash: PackedScene

## Variables
var ammo_count:int 


func _process(delta):
	if Input.is_action_pressed(GameSettings.FIRE):# && fire_mode == GameSettings.WEAPON_FIRE_MODES.AUTO:
		if rof.is_stopped():
			shoot()
	if Input.is_action_just_pressed(GameSettings.FIRE):# && fire_mode == GameSettings.WEAPON_FIRE_MODES.SEMI:
		if rof.is_stopped():
			shoot()
	weaponMesh.position = weaponMesh.position.lerp(weapon_position,delta * recoil_return_rate)	

func shoot() -> void:
	rof.start(1.0/fireRate) #rof
	weaponMesh.position.z += recoil
	
	var collision = ray_cast.get_collider()
	if collision:
		printt("Weapon Fired!", ray_cast.get_collider())
		projectile_hit()
	
	muzzleFlash.restart()



func projectile_hit() -> void:
	var hit = hitFlash.instantiate()
	add_child(hit)
	hit.global_position = ray_cast.get_collision_point()
