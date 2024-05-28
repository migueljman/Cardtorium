extends Resource

## A container for positional data used during the course
## of a game. Contains all the data necessary to save and
## load games. However, it contains no game logic
class_name Board

## Defines the terrain types
enum Terrain {GRASS = -1, FOREST, MOUNTAIN, WATER}

## 2D array which stores the terrain data for each grid
## of the board
@export var tiles: Array = []

## 2D array which stores territory data.
## A -1 means that the tile is unclaimed, whereas
## a nonnegative integer means that the tile has been
## claimed by player with that local id.
@export var territory: Array = []

## 2D array which stores card locations.
@export var units: Array = []

## Stores the players of the game.
@export var players: Array[Player] = []

## Which player is currently taking their turn
@export var current_player: int = 0

## The number of turns taken in the game
@export var turns: int = 0

## Array which stores the position of buildings.
## Cities are included in this array.
@export var buildings: Array = []

## The size of the board (in tiles) encoded as a vector
@export var SIZE: Vector2i

## The number of players in the game.
@export var num_players: int

## Allocates memory to set up an empty board with wid x height tiles.
func setup(wid: int, height: int, _num_players: int):
	# Allocates memeory for the tiles. 
	self.SIZE = Vector2i(wid, height)
	tiles.resize(wid)
	territory.resize(wid)
	units.resize(wid)
	buildings.resize(wid)
	for x in range(wid):
		# Sets the tiles
		tiles[x] = []
		tiles[x].resize(height)
		tiles[x].fill(Terrain.GRASS)
		# Sets the territory
		territory[x] = []
		territory[x].resize(height)
		territory[x].fill( - 1)
		# Sets the units array
		units[x] = []
		units[x].resize(height)
		units[x].fill(null)
		# Sets the buildings array
		buildings[x] = []
		buildings[x].resize(height)
		buildings[x].fill(null)
	players = []
	# TODO: Replace code below, and actually use the `num_players` variable
	var card1: Card = load('res://Cards/Troops/troop_1.tres')
	var card2: Card = load('res://Cards/Troops/troop_2.tres')
	var card4: Card = load('res://Cards/Troops/troop_4.tres')
	var card5: Card = load('res://Cards/Troops/troop_5.tres')
	var card7: Card = load('res://Cards/Troops/troop_7.tres')
	var card8: Card = load('res://Cards/Troops/troop_8.tres')
	var card9: Card = load('res://Cards/Troops/troop_9.tres')
	var card10: Card = load('res://Cards/Troops/troop_10.tres')
	var card11: Card = load('res://Cards/Troops/troop_11.tres')
	var card12: Card = load('res://Cards/Troops/troop_12.tres')
	var card13: Card = load('res://Cards/Troops/troop_13.tres')
	var card14: Card = load('res://Cards/Troops/troop_14.tres')
	var card15: Card = load('res://Cards/Troops/troop_15.tres')
	var card16: Card = load('res://Cards/Troops/troop_16.tres')
	var card17: Card = load('res://Cards/Troops/troop_17.tres')
	var card18: Card = load('res://Cards/Troops/troop_18.tres')
	var card19: Card = load('res://Cards/Troops/troop_19.tres')
	var card20: Card = load('res://Cards/Troops/troop_20.tres')
	var card21: Card = load('res://Cards/Troops/troop_21.tres')
	var card22: Card = load('res://Cards/Troops/troop_22.tres')
	var card23: Card = load('res://Cards/Troops/troop_23.tres')
	var card24: Card = load('res://Cards/Troops/troop_24.tres')
	
	var deck1: Array[Card] = [
		card17, card2, card4, # three of each common the deck uses
		card17, card2, card4,
		card17, card2, card4,
		card1, card9, card15, # two of each uncommon
		card1, card9, card15,
		card7, card10, card16, # one of each rare+
	]
	
	var deck2: Array[Card] = [
		card17, card13, card4, # three of each common the deck uses
		card17, card13, card4,
		card17, card13, card4,
		card8, card19, card18,
		card8, card19, card18,
		card21, card22, card14,
	]
	players.append(Player.new(SIZE, deck1))
	players.append(Player.new(SIZE, deck2))
	# Vector2i(0,SIZE.y / 2), 
	# Vector2i(SIZE.x - 1,SIZE.y / 2), 
	# TODO the name should be read from somewhere else, maybe the main menu
	players[0].name = PlayerInfo.p1_name
	players[1].name = PlayerInfo.p2_name
	
	num_players = _num_players
