extends CanvasLayer
class_name UI

@onready var pause_screen = $PauseScreen
@onready var pause_container = $PauseScreen/PauseContainer
@onready var resume_button = $PauseScreen/PauseContainer/VBoxContainer/Resume

var paused := false:
	set(value):
		paused = value
		pause_screen.visible = paused
		if paused:
			# Make the mouse visible, focus the resume button and pause the tree.
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			resume_button.grab_focus()
			# This menu ignores pause mode so it can still be used.
			get_tree().paused = true
		else:
			# Capture the mouse and unpause the game.
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false

func _on_resume_pressed():
	paused = false


func _on_quit_pressed():
	get_tree().quit()
