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

#Applies splash damage to enemy

func apply_splash_damage(troop_defender: Troop, troop_attacker: Troop):
    var atk_force  = troop_attacker.attack * float(troop_attacker.current_health)/float(troop_attacker.max_health)
    var def_force = troop_defender.defense * float(troop_defender.current_health)/float(troop_defender.max_health)
    var damage = floor((atk_force / (atk_force+def_force)) * troop_attacker.attack)
    var splash_damage = floor(damage / 2.0)

    troop_defender.health -= splash_damage
    if troop_defender.health <= 0:
        troop_defender.health = 0
        parent.game.remove_unit(troop_defender)
