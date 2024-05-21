extends Control

# Setup scene stuff
@onready var nam_lne = $MarginContainer/VBoxContainer/Name/Input as LineEdit
@onready var dec_but = $MarginContainer/VBoxContainer/Deck/Input as OptionButton
@onready var imp_but = $MarginContainer/VBoxContainer/Imperator/Input as OptionButton
@onready var ter_but = $MarginContainer/VBoxContainer/Terrain/Input as OptionButton
@onready var don_but = $MarginContainer/VBoxContainer/Done/Done as Button

# Possible scenes to load into
@export var player2 = load ("res://Scenes/Player_Info/player2_info.tscn") as PackedScene
@export var start_level = load ("res://Scenes/Local_Multiplayer/local_multiplayer.tscn") as PackedScene

# Dictionaries for dropdowns
const DECK_DICTIONARY: Dictionary = {
	"Select a Deck": null,
	"Deck1": 1,
	"Deck2": 2,
	"Deck3": 3
}
const IMPERATOR_DICTIONARY: Dictionary = {
	"Select an Imperator": null,
	"Revitalizer": 16,
	"Plasmagic Ranger": 14
}
const TERRAIN_DICTIONARY: Dictionary = {
	"Select a preferred Terrain": null,
	"Grass": -1,
	"Forest": 0,
	"Mountain": 1,
	"Water": 2
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup which player we are getting info for
	var p
	if get_tree().current_scene.name == "player1_info": p = 0
	elif get_tree().current_scene.name == "player2_info": p = 1
	# Fill in the dropdowns
	add_deck_items()
	add_imperator_items()
	add_terrain_items()
	# Connect the scene elements to their script functions
	dec_but.item_selected.connect(set_deck.bind(p))
	imp_but.item_selected.connect(set_imperator.bind(p))
	ter_but.item_selected.connect(set_terrain.bind(p))
	nam_lne.text_changed.connect(set_nam.bind(p))
	don_but.button_down.connect(on_done_pressed.bind(p))

## Add items to the dropdown
func add_deck_items() -> void:
	for dec in DECK_DICTIONARY: 
		dec_but.add_item(dec)
	
func add_imperator_items() -> void:
	for imp in IMPERATOR_DICTIONARY: 
		imp_but.add_item(imp)
	
func add_terrain_items() -> void:
	for ter in TERRAIN_DICTIONARY:
		ter_but.add_item(ter)

## Set the data such that it can be accessed gloabally
func set_nam(text: String, p: int):
	if p: PlayerInfo.p2_name = text
	else: PlayerInfo.p1_name = text

func set_deck(index: int, p: int):
	if p: PlayerInfo.p2_deck = DECK_DICTIONARY[dec_but.get_item_text(index)]
	else: PlayerInfo.p1_deck = DECK_DICTIONARY[dec_but.get_item_text(index)]

func set_imperator(index: int, p: int):
	if p: PlayerInfo.p2_impe = IMPERATOR_DICTIONARY[imp_but.get_item_text(index)]
	else: PlayerInfo.p1_impe = IMPERATOR_DICTIONARY[imp_but.get_item_text(index)]

func set_terrain(index: int, p: int):
	if p: PlayerInfo.p2_terr = TERRAIN_DICTIONARY[ter_but.get_item_text(index)]
	else: PlayerInfo.p1_terr = TERRAIN_DICTIONARY[ter_but.get_item_text(index)]

## Move on to next scene
func on_done_pressed(p: int):
	# TODO Make a scene or something that is loaded if not everything is set
	if p: get_tree().change_scene_to_packed(start_level)
	else: get_tree().change_scene_to_packed(player2)
