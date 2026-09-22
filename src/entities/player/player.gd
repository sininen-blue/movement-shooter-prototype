class_name Player
extends CharacterBody3D


signal player_jumped()
signal player_crouched()
signal player_uncrouched()
signal player_wall_jumped()

@export var slipper: PackedScene
@export var mouse_sens: float = 0.1
@export var mass: float = 5.0


var input_dir: Vector2
var direction: Vector3
var wish_vel := Vector3.ZERO

var can_jump: bool = false
var has_jumped: bool = false
var jump_queued: bool = false

var can_crouch: bool = false
var has_crouched: bool = false
var crouch_queued: bool = false

var left_wall: bool = false
var right_wall: bool = false
var can_wallrun_left: bool = true
var can_wallrun_right: bool = true

var can_wall_jump: bool = false
var wall_jump_queued: bool = false


@onready var wall_jump_queue_timeout: Timer = %WallJumpQueueTimeout
@onready var crouch_queue_timeout: Timer = %CrouchQueueTimeout
@onready var jump_queue_timeout: Timer = %JumpQueueTimeout
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var head: Marker3D = $Head


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()


	if event.is_action_released("throw"):
		var slipper_instance = slipper.instantiate()
		slipper_instance.direction = -head.global_transform.basis.z
		get_parent().add_child(slipper_instance)
		slipper_instance.global_position = head.global_position
		
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sens
		head.rotation_degrees.x -= event.relative.y * mouse_sens
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -89, 89)


func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


	# jump input
	if is_on_floor():
		coyote_timer.start()
	if Input.is_action_just_pressed("move_jump"):
		jump_queue_timeout.start()

	can_jump = !coyote_timer.is_stopped()
	jump_queued = !jump_queue_timeout.is_stopped()

	if can_jump and jump_queued and !has_jumped:
		jump_queue_timeout.stop()
		coyote_timer.stop()
		has_jumped = true
		player_jumped.emit()
	

	# crouch input
	if Input.is_action_just_pressed("move_crouch"):
		crouch_queue_timeout.start()

	can_crouch = is_on_floor()
	crouch_queued = !crouch_queue_timeout.is_stopped()

	if can_crouch and crouch_queued:
		has_crouched = true
		crouch_queue_timeout.stop()
		player_crouched.emit()
	
	if has_crouched and Input.is_action_just_released("move_crouch"):
		has_crouched = false
		crouch_queue_timeout.stop()
		player_uncrouched.emit()
	
	# walljump input
	if Input.is_action_just_pressed("move_wall_jump") and can_wall_jump:
		wall_jump_queue_timeout.start()
	
	wall_jump_queued = !wall_jump_queue_timeout.is_stopped()
	if can_wall_jump and wall_jump_queued:
		wall_jump_queue_timeout.stop()
		player_wall_jumped.emit()
	
	
	move_and_slide()


func update_wall_collisions() -> void:
	var last_col: Vector3 = get_last_slide_collision().get_position()
	var local_col: Vector3 = head.to_local(last_col)
	
	if local_col.x > 0:
		left_wall = false
		right_wall = true
	else:
		left_wall = true
		right_wall = false


func get_horizontal_speed() -> float:
	return Vector2(velocity.x, velocity.y).length()


func get_horizontal_wish_speed() -> float:
	return Vector2(wish_vel.x, wish_vel.y).length()
