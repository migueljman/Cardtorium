extends Node2D

@onready var winner_label = $MarginContainer/HBoxContainer/VBoxContainer/Player as Label

var winner: int
		
func _ready():
	update_winner_label()

func on_quit_pressed():
	get_tree().quit()

func update_winner_label():
	winner_label.text = "Game Over"

func _on_quit_pressed():
	get_tree().quit()
