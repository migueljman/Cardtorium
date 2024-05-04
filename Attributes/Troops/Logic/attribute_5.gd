extends TroopAttribute

# Logic for splash attribute
#loops to all tiles around defender and applies half damage

func on_attack(defender: Unit):
    var defender_pos = defender.pos
    var splash_tiles = defender._get_surrounding(defender_pos, 1)
    logger.debug('troop_attribute', '(SPLASH) Checking for units in range')

    logger.indent('troop_attribute')
    for tile in splash_tiles:
        var unit_at_tile = board.units[tile.x][tile.y]
        if unit_at_tile != null:
            logger.debug('troop_attribute', '(SPLASH) Applying damage to %s at (%d, %d)'
                % [unit_at_tile.base_stats.name, unit_at_tile.pos.x, unit_at_tile.pos.y])
            apply_splash_damage(unit_at_tile)
    logger.dedent('troop_attribute')

#Applies splash damage to enemy

func apply_splash_damage(defender: Troop):
    var atk_force  = parent.attack * float(parent.current_health)/float(parent.max_health)
    var def_force = defender.defense * float(defender.current_health)/float(defender.max_health)
    var damage = (atk_force / (atk_force+def_force)) * parent.attack
    var splash_damage: int = floor(damage / 2.0)

    defender.health -= splash_damage
    if defender.health <= 0:
        defender.health = 0
        parent.game.remove_unit(defender)
