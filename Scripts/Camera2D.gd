extends Camera2D

export (int) var velocidad = 300

func _physics_process(delta):
	if !Global.cinematica:
		position.x += velocidad*delta
