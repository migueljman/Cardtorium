extends Control
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var load_button = $MarginContainer/HBoxContainer/VBoxContainer/Load_Button as Button
@onready var margin_container = $MarginContainer as MarginContainer
@export var start_level = preload ("res://Scenes/Local_Multiplayer/local_multiplayer.tscn") as PackedScene
var local_multiplayer = null
			
func _ready():
	handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_load_pressed() -> void:
	load_game()

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	load_button.button_down.connect(on_load_pressed)

func load_game() -> void:
	if ResourceLoader.exists("user://local_multiplayer.tres"):
		var packed_scene = ResourceLoader.load("user://local_multiplayer.tres") # as PackedScene
		if packed_scene != null:
			print("Loading user://local_multiplayer.tres...")
			get_tree().change_scene_to_packed(packed_scene)
		else:
			print("Failed to load scene: user://local_multiplayer.tres")
			
# const DECK: Array[String] = [
# 	"Deck 1",
# 	"Deck 2",
# 	"Deck 3"
# ]
