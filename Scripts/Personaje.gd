extends KinematicBody2D

export (int) var velocidad= 800
var movimiento = Vector2.ZERO
var cooldown = true;
var powerup = false;
onready var Disparo = preload("res://Scenes/Disparo.tscn")
onready var HUD = get_tree().get_nodes_in_group("hud")[0]
onready var DisparoEspecial = preload("res://Scenes/DisparoEspecial.tscn")

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():
	Global.vidas = 3
	Global.labelPuntos = HUD.get_node("BarraPuntos/Label")

func _get_inputs():
	movimiento=Vector2()
	if Input.is_action_pressed("ui_down"):
		movimiento.y+=velocidad
	if Input.is_action_pressed("ui_up"):
		movimiento.y-=velocidad
	if Input.is_action_pressed("ui_left"):
		movimiento.x-=velocidad
		playback.travel("move_left")
	if Input.is_action_pressed("ui_right"):
		movimiento.x+=velocidad
		playback.travel("move_right")
	if Input.is_action_pressed("space"):
		disparar()
		
	if movimiento==Vector2():
		playback.start("RESET")

func disparar():
	if cooldown:
		cooldown = false
		$Timer.start()
		$AudioStreamPlayer.play()
		var instancia_disparo
		if powerup == true:
			instancia_disparo = DisparoEspecial.instance()
		else:
			instancia_disparo= Disparo.instance()
		instancia_disparo.global_position = $Disparo_position.global_position
		add_child(instancia_disparo)
		instancia_disparo.set_as_toplevel(true)
	
func _physics_process(delta):
	if !Global.cinematica:
		_get_inputs()
		movimiento = move_and_slide(movimiento)
		if is_on_wall():
			take_damage()


func _on_Timer_timeout():
	cooldown=true
	
func take_damage():
	Global.remove_vida()
	var barra_vida = HUD.get_node("BarraVida")
	var vidas = barra_vida.get_children()
	vidas[Global.vidas].visible = false
	$DamageAnim.play("take_damage")

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemigo"):
		take_damage()
		area.set_explosion()
