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

var is_attack : bool = false
var combo_count : int = 0
var combo_timer : float = 0
@export var combo_timeout : float = 0.3

var attack_buffer : bool
@onready var attack_buffer_timer: Timer = $AttackBufferTimer

@onready var atk_1: CollisionShape2D = $HitBox/ATK1
@onready var atk_2: CollisionShape2D = $HitBox/ATK2
@onready var atk_3: CollisionShape2D = $HitBox/ATK3

func _ready() -> void:
	visual.animation_finished.connect(_animation_end)

func _physics_process(delta: float) -> void:
	if !is_attack and combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_count = 0
	
	var Xaxis = Input.get_axis("left","right")
	if is_attack: Xaxis = 0
	
	if !is_on_floor():
		if coyote_timer.is_stopped():
			coyote_timer.start()
		
		velocity.y += get_gravity().y * delta
		
		if !is_attack:
			if velocity.y < 0:
				visual.play("Up")
			else:
				visual.play("Fall")
	else:
		can_jump = true
		if !is_attack:
			if velocity.x != 0:
				visual.play("Run")
			else:
				visual.play("Idle")
	
	if Input.is_action_just_pressed("jump"):
		JumpBuffer = true
		buffer_timer.start()
	
	if Input.is_action_just_pressed("attack"):
		attack_buffer = true
		attack_buffer_timer.start()
	
	if JumpBuffer and can_jump:
			velocity.y = JumpForce
			can_jump = false
			JumpBuffer = false
	
	if attack_buffer and !is_attack:
		_performance_attack()
	
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

func _performance_attack():
	combo_count += 1
	
	if combo_count > 0:
		if combo_count > 3:
			combo_count = 1
		is_attack = true
		combo_timer = combo_timeout
		
		var animation_name : String = "atk" + str(combo_count)
		visual.play(animation_name)
		if combo_count == 1:
			atk_1.disabled = false
			await visual.animation_finished
			atk_1.disabled = true
		elif combo_count == 2:
			atk_2.disabled = false
			await visual.animation_finished
			atk_2.disabled = true
		elif combo_count == 3:
			atk_3.disabled = false
			await visual.animation_finished
			atk_3.disabled = true

func _animation_end():
	if is_attack:
		is_attack = false

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


func _on_attack_buffer_timeout() -> void:
	attack_buffer = false


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage(15)
