extends TroopAttribute

# Logic for splash attribute
#loops to all tiles around defender and applies half damage

func on_attack(defender: Unit, attacker: Unit):
    var defender_pos = defender.pos
    var splash_tiles = defender._get_surrounding(defender_pos, 1)

    for tile in splash_tiles:
        var unit_at_tile = board.units[tile.x][tile.y]
        if unit_at_tile != null:
            apply_splash_damage(unit_at_tile, attacker)

#Applies half attack damage to enemy

func apply_splash_damage(troop_defender: Troop, troop_attacker: Troop):
    var splash_damage = floor(troop_attacker.attack / 2.0)
    troop_defender.health -= splash_damage
    if troop_defender.health <= 0:
        troop_defender.health = 0
        parent.game.remove_unit(troop_defender)
