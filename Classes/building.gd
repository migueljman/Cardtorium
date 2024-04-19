extends Unit

## Class which represents buildings in the game
class_name Building

## The building's attributes
var attributes: Array[BuildingAttribute] = []


## Creates a new building from a corresponding card
func _init(_game: Game, card: Card = null):
    # Loads stats
    base_stats = card
    game = _game
    attack = base_stats.attack
    health = base_stats.health
    rng = base_stats.attack_range
    # Loads attributes
    for attribute_id in card.attributes:
        var attribute_file = load('res://Attributes/Buildings/Logic/attribute_{0}.gd'.format({0:attribute_id}))
        if attribute_file == null:
            continue
        var attribute: BuildingAttribute = attribute_file.new()
        attribute.setup(attribute_id, game, self)
        attributes.append(attribute)