extends Area2D

var speed = 300  # Initial speed
var velocity = Vector2.ZERO
var screensize = Vector2.ZERO

func _ready():
	screensize = get_viewport_rect().size
	velocity = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized() * speed

func _process(delta):
	position += velocity * delta

	if position.x <= 0 or position.x >= screensize.x:
		velocity.x = -velocity.x
	if position.y <= 0 or position.y >= screensize.y:
		velocity.y = -velocity.y

	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

func set_speed(new_speed):
	speed = new_speed
	velocity = velocity.normalized() * speed
