extends TroopAttribute

# Logic for the Healer attribute

func build_action() -> Action:
	logger.debug('troop_attribute', '(HEALER) Building the \'Heal\' action')
	var action: Action = Action.new()
	action.name = "Healer"
	action.description = attribute.description
	action.setup(parent.game, heal_nearby)
	return action

func heal_nearby():
	logger.log('troop_attribute', '(HEALER) Healing units in a 1-tile radius')
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
			var ally: Troop = board.units[x][y]
			if ally.owned_by == parent.owned_by:
				var amount: int = parent.health / 4
				ally.health = clampi(ally.health + amount, 0, ally.base_stats.health)
				ally.damaged.emit()
				logger.debug('troop_attribute', '(HEALER) Healing unit at (%d, %d)' % [ally.pos.x, ally.pos.y])
	logger.dedent('troop_attribute')
