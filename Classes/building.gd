extends Unit

## Class which represents buildings in the game
class_name Building

## The building's attributes
var attributes: Array[BuildingAttribute] = []
## Whether or not the building can do actions
var can_act: bool = false
## All actions that the building can take
var actions: Array[Action]


## Creates a new building from a corresponding card
func _init(_game: Game, card: Card = null):
    # Loads stats
    base_stats = card
    game = _game
    attack = base_stats.attack
    health = base_stats.health
    rng = base_stats.attack_range
    owned_by = game.board.current_player
    # Loads attributes
    for attribute_id in card.attributes:
        var attribute_file = load('res://Attributes/Buildings/Logic/attribute_{0}.gd'.format({0:attribute_id}))
        if attribute_file == null:
            continue
        var attribute: BuildingAttribute = attribute_file.new()
        attribute.setup(attribute_id, game, self)
        attributes.append(attribute)

## Determines which tiles the building can be placed on
func get_placeable_tiles() -> Array[Vector2i]:
    var tiles: Array[Vector2i] = []
    for x in range(game.board.SIZE.x):
        for y in range(game.board.SIZE.x):
            if game.board.buildings[x][y] != null:
                continue
            elif game.board.territory[x][y] != owned_by:
                continue
            elif game.board.tiles[x][y] != Board.Terrain.GRASS:
                continue
            tiles.append(Vector2i(x, y))
    return tiles

## Runs through attributes, and fills out the actions array.
func build_action_list():
    actions = []
    if not can_act:
        return
    # Adds attribute actions
    for attr in attributes:
        var action = attr.build_action()
        if action != null:
            actions.append(action)

## Clears action list
func clear():
    actions = []

## Resets the building at the end of a turn.
func reset(prev: int, player: Player):
    clear()
    can_act = true
	# Sets all stats back to default
    attack = base_stats.attack
    rng = base_stats.attack_range
    # Runs through attributes
    for attr in attributes:
        attr.reset()