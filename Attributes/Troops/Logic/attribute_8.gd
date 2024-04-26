extends TroopAttribute

# Logic for survivalist attribute

## Overrides this function from TroopAttributes and returns a non-null value to change the move calculation.
## For information on the parameters, see [method Troop._calc_move_cost]
func calc_move_cost(strength: float, from: Vector2i, to: Vector2i, board: Board):

	# Checks if the move is even discovered
	if not board.players[self.owned_by].discovered[to.x][to.y]:
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

	var dest_type: Board.Terrain = board.tiles[to.x][to.y]

	# Checks for forest terrain and overrides if so
	if dest_type == Board.Terrain.FOREST:
		return max(strength - 1, 0)
	else:
		return null
