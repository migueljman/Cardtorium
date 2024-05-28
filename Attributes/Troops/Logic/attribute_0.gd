extends TroopAttribute

# Contains the logic for the dash attribute

@export
var has_attacked: bool = false

func on_attack(defender: Unit):
    logger.debug('troop_attribute', '(DASH) Setting has_attacked = true')
    has_attacked = true

func on_moved(from: Vector2i, to: Vector2i):
    if not has_attacked:
        logger.debug('troop_attribute', '(DASH) Overriding can_attack to true')
        parent.can_attack = true

func reset():
    logger.debug('troop_attribute', '(DASH) Setting has_attacked = false')
    has_attacked = false