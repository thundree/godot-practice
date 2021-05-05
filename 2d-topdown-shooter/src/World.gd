extends Node2D

var Match = preload("res://src/Match.tscn")
var match_ongoing = false

func start_game():
	match_ongoing = true	
	$StartMenu.visible = false
	add_child(Match.instance())

func reset_game():
	match_ongoing = false
	$StartMenu.visible = true
	$Match.queue_free()

func _input(event):
	if event is InputEventKey and event.pressed and not match_ongoing:
		if event.scancode != KEY_ENTER:
			start_game()
