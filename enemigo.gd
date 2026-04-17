extends Area2D

var healt : float = 30

func damage(dmg : float):
	print(dmg)
	healt -= dmg
	if healt <= 0:
		queue_free()
