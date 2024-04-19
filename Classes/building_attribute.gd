extends Node

class_name BuildingAttribute

## Stores the attribute data
var attribute: Attribute
## Building object that is being modified
var parent: Building
## The game state
var board: Board

## Attaches the building attribute to a game object and a building object.
## Also sets up the attribute's description.
func setup(attribute_id: int, game: Game, building: Building):
    attribute = load("res://Attributes/Buildings/Data/attribute_{0}.tres".format({0: attribute_id}))
    parent = building
    board = game.board