extends Area2D

var screensize = Vector2.ZERO

func pickup():
	queue_free()

func level_end():
	queue_free()
