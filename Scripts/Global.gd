extends Node

var puntos = 0
var vidas = 3
var labelPuntos
var cinematica = false

func remove_vida():
	if vidas>1:
		vidas -= 1
	else:
		get_tree().reload_current_scene()

func add_puntos(valor):
	puntos += valor
	labelPuntos.text = String(puntos)
