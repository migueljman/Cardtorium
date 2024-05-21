extends Control

@onready var nam_lne = $MarginContainer/VBoxContainer/Name/Input as LineEdit
@onready var dec_but = $MarginContainer/VBoxContainer/Deck/Input as OptionButton
@onready var imp_but = $MarginContainer/VBoxContainer/Imperator/Input as OptionButton
@onready var ter_but = $MarginContainer/VBoxContainer/Terrain/Input as OptionButton
@onready var don_but = $MarginContainer/VBoxContainer/Done/Done as Button

@export var player2 = load ("res://Scenes/Player_Info/player2_info.tscn") as PackedScene
@export var start_level = load ("res://Scenes/Local_Multiplayer/local_multiplayer.tscn") as PackedScene

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
	add_deck_items()
	add_imperator_items()
	add_terrain_items()
	dec_but.item_selected.connect(set_deck)
	imp_but.item_selected.connect(set_imperator)
	ter_but.item_selected.connect(set_terrain)
	nam_lne.text_changed.connect(set_nam)
	don_but.button_down.connect(on_done_pressed)

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

## TODO have the selected data be passed into where it needs to be
func set_nam(text: String):
	var pnam = text
	#print(pnam)
func set_deck(index: int):
	var deck = DECK_DICTIONARY[dec_but.get_item_text(index)]
	#print(deck)
func set_imperator(index: int):
	var impe = IMPERATOR_DICTIONARY[imp_but.get_item_text(index)]
	#print(impe)
func set_terrain(index: int):
	var terr = TERRAIN_DICTIONARY[ter_but.get_item_text(index)]
	#print(terr)
func on_done_pressed():
	# TODO Find a way to check that none of the default option are selected
	if get_tree().current_scene.name == "player1_info":
		get_tree().change_scene_to_packed(player2)
	elif get_tree().current_scene.name == "player2_info":
		get_tree().change_scene_to_packed(start_level)
