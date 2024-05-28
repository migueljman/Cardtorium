extends TroopAttribute

# Initiative attribute:
# Contains the logic to perform an action after moving

func on_moved(from: Vector2i, to: Vector2i):
	logger.log('troop_attribute', '(INITVE) Overriding can_act to true')
	parent.can_act = true