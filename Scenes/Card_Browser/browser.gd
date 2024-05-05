extends Control
@onready var back_button = $Back as Button
@onready var items = $ScrollContainer/Items
var card_scene = preload ("res://Scenes/Card_Renderer/small_card.tscn")
var cardsize = Vector2(224, 273)
var max_cards_per_hbox = 4
var current_hbox: HBoxContainer = null
var hbox_count = 0
var card_scale: float = 1
var all_cards: Array

signal exit_browser


## Called when the node enters the scene tree for the first time.
func _ready():
	back_button.button_down.connect(on_exit_browser_pressed)
	set_process(false)
	var scroll = $ScrollContainer
	scroll.scale = Vector2(card_scale, card_scale)
	scroll.size /= card_scale
	load_and_display_cards()


## Connects to the exit_brower button
func on_exit_browser_pressed():
	exit_browser.emit()
	set_process(false)

## Adds a card to the currently processed hbox
func add_card(card_data: Resource, card_index: int):
	# if current_hbox == null or current_hbox.get_child_count() >= max_cards_per_hbox:
	# 	new_hbox()
	var card = card_scene.instantiate()
	# current_hbox.add_child(card)
	# current_hbox.add_theme_constant_override("separation", 10)
	items.add_child(card)
	card.setup(card_data, card_index)
	all_cards.append(card)

## Creates a new hbox
func new_hbox():
	current_hbox = HBoxContainer.new()
	items.add_child(current_hbox)
	hbox_count += 1

## Displays every Cardtorium card in the browser
func load_and_display_cards():
	var dir = DirAccess.open("res://Cards/Troops/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".tres"):
				var card_data = load("res://Cards/Troops/" + file_name)
				add_card(card_data, hbox_count * max_cards_per_hbox)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


## Used to sort the cards by name
func order_by_name(card1, card2) -> bool:
	return card1.card.name.to_lower() <= card2.card.name.to_lower()

## Used to sort the cards by rarity. Within a rarity group, cards are ordererd by name.
func order_by_rarity(card1, card2) -> bool:
	var rarity1: Card.CardRarity = card1.card.rarity
	var rarity2: Card.CardRarity = card2.card.rarity
	if rarity1 != rarity2:
		return rarity1 <= rarity2
	else:
		return card1.card.name.to_lower() <= card2.card.name.to_lower()

## Used to sort the cards by cost. Within a cost, cards are ordered by name
func order_by_cost(card1, card2) -> bool:
	var cost1 = card1.card.cost
	var cost2 = card2.card.cost
	if cost1 != cost2:
		return cost1 < cost2
	else:
		return card1.card.name.to_lower() <= card2.card.name.to_lower()

## Sorts the cards
func sort_cards(index: int):
	if index < 0:
		return
	var sort_funcs = [order_by_name, order_by_rarity, order_by_cost]
	all_cards.sort_custom(sort_funcs[index])
	var i: int = 0
	for card in all_cards:
		items.move_child(card, i)
		i += 1