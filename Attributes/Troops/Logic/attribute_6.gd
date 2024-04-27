extends TroopAttribute

# Logic for the Healer attribute

func build_action() -> Action:
    var action: Action = Action.new()
    action.name = "Healer"
    action.description = attribute.description
    action.setup(parent.game, heal_nearby)
    return action

func heal_nearby():
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
            var ally: Troop = board.units[x][y]
            if ally.owned_by == parent.owned_by:
	            var amount: int = parent.health / 4
	            ally.health = clampi(ally.heath + amount, 0, ally.base_stats.health)
                