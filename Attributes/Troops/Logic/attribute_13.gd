extends TroopAttribute

# Logic for the rally attribute

var mult: float = 0.5

func build_action() -> Action:
    logger.debug('troop_attribute', '(RALLY) Building the "rally" action')
    var action: Action = Action.new()
    action.name = attribute.name
    action.description = attribute.description
    action.setup(parent.game, buff_nearby)
    return action

func buff_nearby():
    logger.log('troop_attribute', '(RALLY) Buffing troops in a 1-tile radius')
    logger.indent('troop_attribute')
    for x in range(parent.pos.x - 1, parent.pos.x + 2):
        if x < 0:
            continue
        elif x >= board.SIZE.x:
            break
        for y in range(parent.pos.y - 1, parent.pos.y + 2):
            if y < 0:
                continue
            elif y >= board.SIZE.y:
                break
            if board.units[x][y] == null:
                continue
            var troop: Troop = board.units[x][y]
            if troop.owned_by == parent.owned_by:
                logger.debug('troop_attribute', '(RALLY) Buffing %s at (%d, %d)' % [troop.base_stats.name, troop.pos.x, troop.pos.y])
                troop.defense += int(troop.base_stats.defense * mult)
                troop.attack += int(troop.base_stats.attack * mult)
    logger.dedent('troop_attribute')