extends CharacterBody2D

@export var MaxSpeed : float = 300
@export var JumpForce : float = -400
@export var Acc : float = 21
@export var Dcc : float = 15

@export var correction_ämount : float = 2

@onready var visual: AnimatedSprite2D = $Visual

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
var can_jump : bool
var JumpBuffer : bool

@onready var ray_der: RayCast2D = $RayDer
@onready var ray_izq: RayCast2D = $RayIzq

func _physics_process(delta: float) -> void:
	var Xaxis = Input.get_axis("left","right")
	
	if !is_on_floor():
		if coyote_timer.is_stopped():
			coyote_timer.start()
		
		velocity.y += get_gravity().y * delta
		
		if velocity.y < 0:
			visual.play("Up")
		else:
			visual.play("Fall")
	else:
		can_jump = true
		if velocity.x != 0:
			visual.play("Run")
		else:
			visual.play("Idle")
	
	if Input.is_action_just_pressed("jump"):
		JumpBuffer = true
		buffer_timer.start()
	
	if JumpBuffer and can_jump:
			velocity.y = JumpForce
			can_jump = false
			JumpBuffer = false
	
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y /= 2
	
	var target_speed = Xaxis * MaxSpeed
	if Xaxis != 0:
		visual.flip_h = Xaxis < 0
		velocity.x = move_toward(velocity.x, target_speed, Acc)
	else:
		velocity.x = move_toward(velocity.x, target_speed, Dcc)
	
	move_and_slide()
	
	if velocity.y < 0:
		_corner_correction()

func _corner_correction():
	ray_der.force_raycast_update()
	ray_izq.force_raycast_update()
	
	if ray_der.is_colliding() and !ray_izq.is_colliding():
		global_position.x -= correction_ämount
	
	if !ray_der.is_colliding() and ray_izq.is_colliding():
		global_position.x += correction_ämount

func _on_coyote_timer_timeout() -> void:
	can_jump = false


func _on_buffer_timer_timeout() -> void:
	JumpBuffer = false
