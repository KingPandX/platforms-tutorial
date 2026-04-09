extends CharacterBody2D

@export var MaxSpeed : float = 300
@export var JumpForce : float = -400
@export var Acc : float = 21
@export var Dcc : float = 15
@onready var visual: AnimatedSprite2D = $Visual

func _physics_process(delta: float) -> void:
	var Xaxis = Input.get_axis("left","right")
	
	if !is_on_floor():
		velocity.y += get_gravity().y * delta
		if velocity.y < 0:
			visual.play("Up")
		else:
			visual.play("Fall")
	else:
		if velocity.x != 0:
			visual.play("Run")
		else:
			visual.play("Idle")
		if Input.is_action_just_pressed("jump"):
			velocity.y = JumpForce
	
	velocity.x = Xaxis * MaxSpeed
	if Xaxis != 0:
		visual.flip_h = Xaxis < 0
	
	move_and_slide()
