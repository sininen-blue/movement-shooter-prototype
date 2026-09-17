class_name Player
extends CharacterBody3D


signal player_jumped()


@export var mouse_sens: float = 0.1


var input_dir: Vector2
var direction: Vector3
var wish_vel := Vector3.ZERO

var can_jump: bool = false
var has_jumped: bool = false
var jump_queued: bool = false


@onready var coyote_timer: Timer = %CoyoteTimer
@onready var head: Marker3D = $Head


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
		
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sens
		head.rotation_degrees.x -= event.relative.y * mouse_sens
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -89, 89)


func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor() and is_on_wall_only():
		coyote_timer.start()

	can_jump = coyote_timer.is_stopped() == false

	if Input.is_action_just_pressed("move_jump"):
		jump_queued = true
	
	if can_jump and jump_queued and !has_jumped:
		has_jumped = true
		player_jumped.emit()

	move_and_slide()
