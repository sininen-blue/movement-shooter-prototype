class_name Player
extends CharacterBody3D


@export var sensitivity: float = 0.1
@export var bunny_hop_curve: Curve

var input_dir: Vector2
var direction: Vector3
var wish_vel := Vector3.ZERO
var highest_run: float 

@onready var head: Marker3D = $Head
@onready var speed: Label = $CanvasLayer/Control/VBoxContainer/Speed
@onready var velocity_arrow: CSGBox3D = $VelocityArrow
@onready var wish_velocity_arrow: CSGBox3D = $WishVelocityArrow


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_reload"):
		get_tree().reload_current_scene()
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * sensitivity
		head.rotation_degrees.x -= event.relative.y * sensitivity
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -80, 80)


func _process(_delta: float) -> void:
	velocity_arrow.look_at(velocity + global_position)
	velocity_arrow.size.z = velocity.length()
	
	
	wish_velocity_arrow.look_at(wish_vel + global_position)
	wish_velocity_arrow.size.z = wish_vel.length()


func _physics_process(_delta: float) -> void:
	speed.text = "horizontal vel: " + str(Vector2(velocity.x, velocity.z).length())
	
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	move_and_slide()
