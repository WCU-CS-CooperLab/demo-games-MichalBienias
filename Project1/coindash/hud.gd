extends CanvasLayer

signal start_game

func update_score(value):
	$MarginContainer/Score.text = str(value)

func update_timer(value):
	$MarginContainer/Time.text = str(value)
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()
	
func _on_timer_timeout():
	$Message.hide()
	
func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	
func show_win():
	show_message("You Win!")
	$StartButton.text = "Retry"
	$StartButton.show()
	$Message.show()

func show_game_over():
	$Timer.start()
	show_message("Game Over")
	$StartButton.text = "Retry"
	await $Timer.timeout
	$StartButton.show()
	$Message.text = "Coin Dash"
	$Message.show()
