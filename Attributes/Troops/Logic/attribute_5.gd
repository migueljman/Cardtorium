extends TroopAttribute

# Logic for splash attribute

func build_action() -> Action:
    var action: Action = Action.new()
    action.name = attribute.name
    action.description = attribute.description
    action.setup(parent.game, on_attack)
    return action

#loops to all tiles around defender and applies half damage

func on_attack(defender: Unit):
    var defender_pos = defender.pos
    var splash_tiles = _get_surrounding(defender_pos, 1)

    for tile in splash_tiles:
        var unit_at_tile = game.board.units[tile.x][tile.y]
        apply_splash_damage(unit_at_tile)

#Applies half attack damage to enemy

func apply_splash_damage(troop: Troop):
    var splash_damage = floor(base_stats.attack / 2.0)
    troop.health -= splash_damage
    if troop.health <= 0:
        troop.health = 0
        game.remove_unit(troop)
