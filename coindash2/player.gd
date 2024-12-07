extends Area2D

signal pickup
signal hurt
signal gameover

@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

func _process(delta):
	# Get input and update player position
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta

	# Ensure the player stays within the screen boundaries
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	# Update animation based on player movement
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"

	# Flip the sprite based on horizontal movement direction
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start():
	set_process(true)
	$AnimatedSprite2D.animation = "idle"

func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

func _on_area_entered(area):
	# Handle interactions with different objects
	if area.is_in_group("coins"):
		area.queue_free()  # Remove the coin from the scene
		emit_signal("pickup")
	elif area.is_in_group("fire"):
		emit_signal("hurt")
		emit_signal("gameover")
		die()  # Call die() to handle the player's death
	elif area.is_in_group("boosts"):
		area.queue_free()  # Remove the boost from the scene
		emit_signal("pickup")
		speed += 200  # Temporarily increase speed


func _on_gameover() -> void:
	pass # Replace with function body.
