extends Node

@export var coin_scene : PackedScene
@export var boost_scene : PackedScene
@export var fire_scene : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false
var spirits = []
var fire_speed = 300

func _ready():
	$Player.connect("gameover", Callable(self, "game_over")) # Connect player signal to main function
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.position = screensize / 2
	$Player.hide()
	$Fire.hide()
	$HUD.connect("start_game", Callable(self, "start_game"))
	
func new_game():
	$Player.position = screensize / 2
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$Fire.show()
	$GameTimer.start()
	spawn_coins()
	spawn_boost()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func spawn_boost():
	if level % 4 == 0:
		var b = boost_scene.instantiate()
		add_child(b)
		b.screensize = screensize
		b.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		spirits.append(b)
		
func despawn_items():
	for s in spirits:
		if s != null:
			s.pickup()

func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		despawn_items()
		level += 1
		time_left += 5
		fire_speed += 50  # Increase fire speed
		update_fire_speed()  # Update the fire's velocity
		spawn_coins()
		spawn_boost()
	if score > 100:
		win()

func _on_player_hurt():
	game_over() # Replace with function body.


func _on_player_pickup():
	score += 1
	$HUD.update_score(score) # Replace with function body.

func update_fire_speed():
	if $Fire.has_method("set_speed"):
		$Fire.set_speed(fire_speed)

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("boosts", "queue_free")
	$Fire.hide()
	$HUD.show_game_over()
	$Player.die()
	
func start_game():
	new_game()
	
func win():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	get_tree().call_group("boosts", "queue_free")
	$Fire.hide()
	$HUD.show_win()
