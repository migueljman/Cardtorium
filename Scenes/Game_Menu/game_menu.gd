extends Control
@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var load_button = $MarginContainer/HBoxContainer/VBoxContainer/Load_Button as Button
@onready var margin_container = $MarginContainer as MarginContainer
@export var start_level = preload ("res://Scenes/Local_Multiplayer/local_multiplayer.tscn") as PackedScene
@export var player1 = load ("res://Scenes/Player_Info/player1_info.tscn") as PackedScene
var local_multiplayer = null
			
func _ready():
	handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(player1)

func on_load_pressed() -> void:
	load_game()

func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	load_button.button_down.connect(on_load_pressed)

func load_game() -> void:
	var root: Node = start_level.instantiate()
	root.save_data = load("res://game0.tres")
	get_tree().get_root().add_child(root)
	queue_free()
