extends TroopAttribute

# Logic for retreat attribute can go here


func on_attack(defender: Unit):
	logger.debug('troop_attribute', '(RTREAT) Overriding can_move to true')
	parent.can_move = true