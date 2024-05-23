extends TroopAttribute

# Logic for the doctor attribute

func build_action() -> Action:
	logger.debug('troop_attribute', '(DOCTOR) Finding valid tiles for the \'Doctor\' action')
	logger.indent('troop_attribute')
	var options: Array[Vector2i] = []
	for x in range(parent.pos.x - 1, parent.pos.x + 2):
		if x < 0:
			continue
		elif x > board.SIZE.x:
			break
		for y in range(parent.pos.y - 1, parent.pos.y + 2):
			if y < 0:
				continue
			elif y > board.SIZE.y:
				break
			if x == parent.pos.x and y == parent.pos.y:
				continue
			var troop = board.units[x][y]
			if troop == null:
				continue
			elif troop is Troop:
				if troop.owned_by != parent.owned_by:
					continue
				logger.debug('troop_attribute', '(DOCTOR) Found tile at (%d, %d)' % [x, y])
				options.append(Vector2i(x, y))
	logger.dedent('troop_attribute')
	if not options:
		logger.debug('troop_attribute', '(DOCTOR) No tiles found')
		return null
	var action = Action.new()		
	action.setup(parent.game, heal_on_tile, options)
	action.name = "Doctor"
	action.description = attribute.description
	return action


func heal_on_tile(tile: Vector2i):
	var ally: Troop = board.units[tile.x][tile.y]
	logger.log('troop_attribute', '(DOCTOR) Healing troop %s at (%d, %d)' % [ally.base_stats.name, ally.pos.x, ally.pos.y])
	var amount: int = parent.health / 2
	ally.health = clampi(ally.health + amount, 0, ally.base_stats.health)
