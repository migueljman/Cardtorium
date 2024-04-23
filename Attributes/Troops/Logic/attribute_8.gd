extends TroopAttribute

# Logic for survivalist attribute


## Overrides this function from TroopAttributes and returns a non-null value to change the move calculation.
## Removes the forest move penalty, otherwise identical
## For information on the parameters, see [method Troop._calc_move_cost]
func calc_move_cost(strength: float, from: Vector2i, to: Vector2i, board: Board):
	if to.x < 0 or to.y < 0 or to.x >= board.SIZE.x or to.y >= board.SIZE.y:
		return -1
	var dest_type: Board.Terrain = board.tiles[to.x][to.y]
	# Check if the destination tile contains another troop, skip if it does
	var unit_at_destination = board.units[to.x][to.y]
	if unit_at_destination != null and unit_at_destination is Troop:
		return - 1
	# Checks if the move is even discovered
	if not board.players[self.owned_by].discovered[to.x][to.y]:
		return - 1
	# Checks terrain type
    # remove check for forest terrain
	if dest_type == Board.Terrain.MOUNTAIN:
		return 0
	elif dest_type == Board.Terrain.WATER:
		return - 1
	# Checks for zone-of-control
	var temp: Vector2i = Vector2i.ZERO
	for x_off in range(-1, 2):
		temp.x = to.x + x_off
		if temp.x < 0 or temp.x >= board.SIZE.x:
			continue
		for y_off in range(-1, 2):
			temp.y = to.y + y_off
			if temp.y < 0 or temp.y >= board.SIZE.y:
				continue
			var unit: Unit = board.units[temp.x][temp.y]
			if unit != null and owned_by != unit.owned_by:
				return 0
	# TODO: Check if there is an enemy nearby to apply zone-of-control
	return max(strength - 1, 0)