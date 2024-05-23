extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_game_update_unit_info(unit: Unit):
	var form_ret: String
	var actl_ret: String
	
	if unit is Troop:
		form_ret = "[center]Attack: %d\nDefense: %d\nMovement: %d\nRange: %d\n\nCan Move: %s\nCan Attack: %s\nCan Act: %s[/center]"
		actl_ret = form_ret % [unit.attack, unit.defense, unit.movement, unit.rng, "Yes" if unit.can_move else "No", "Yes" if unit.can_attack else "No", "Yes" if unit.can_act else "No"]
	
	set_text(actl_ret)
