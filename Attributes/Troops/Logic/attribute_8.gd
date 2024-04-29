extends TroopAttribute

# Logic for survivalist attribute

## Overrides this function from TroopAttributes and returns an updated dictionary
## For information on the parameters, see [method Troop._calc_move_cost]
func calc_move_cost(strength: float, from: Vector2i, to: Vector2i, board: Board) -> Dictionary:

	var new_dict: Dictionary = {"forest": strength - 1}
	return new_dict
