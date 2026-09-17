class_name WallRaycasts
extends Node3D


@export var cooldown = 0.5


var left_time: float = 0
var right_time: float = 0


@onready var right_wall_cast: RayCast3D = $RightWallCast
@onready var left_wall_cast: RayCast3D = $LeftWallCast


func get_colliding_direction() -> int:
	if left_wall_cast.is_colliding():
		return 0
	if right_wall_cast.is_colliding():
		return 1
	return -1


func is_colliding() -> bool:
	if left_wall_cast.is_colliding():
		return true
	if right_wall_cast.is_colliding():
		return true
	return false


func get_collided() -> Object:
	if left_wall_cast.is_colliding():
		return left_wall_cast.get_collider()
	if right_wall_cast.is_colliding():
		return right_wall_cast.get_collider()
	
	return null


func get_collision_normal() -> Vector3:
	if left_wall_cast.is_colliding():
		return left_wall_cast.get_collision_normal()
	if right_wall_cast.is_colliding():
		return right_wall_cast.get_collision_normal()
		
	return Vector3.ZERO


func start_cooldown(dir: int) -> void:
	if dir == 0:
		left_wall_cast.enabled = false
	if dir == 1:
		right_wall_cast.enabled= false


func _process(delta: float) -> void:
	if left_wall_cast.enabled == false:
		left_time += 1 * delta
	if right_wall_cast.enabled == false:
		right_time += 1 * delta
	
	if left_time >= cooldown:
		left_wall_cast.enabled = true
	if right_time >= cooldown:
		right_wall_cast.enabled = true
