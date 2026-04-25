extends CharacterBody2D
class_name Player

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

func _animation_end():
	if is_attack:
		is_attack = false

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		coyote_timer.start()
	else:
		can_jump = true

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
