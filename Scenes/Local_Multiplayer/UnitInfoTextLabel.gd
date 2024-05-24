extends RichTextLabel

var attrs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_game_update_unit_info(unit: Unit):
	var form_ret: String
	var actl_ret: String
	
	if unit is Troop:
		# Fill in the troop details
		form_ret = "[center][b]%s[/b]\nAttack: %d\nDefense: %d\nMovement: %d\nRange: %d\n\nCan Move: %s\nCan Attack: %s\nCan Act: %s\n\nAttributes:"
		actl_ret = form_ret % [unit.name, unit.attack, unit.defense, unit.movement, unit.rng, "Yes" if unit.can_move else "No", "Yes" if unit.can_attack else "No", "Yes" if unit.can_act else "No"]
	
	# Fill in the attribute Details
	var names = []
	var count = 0
	attrs = []
	for attr in unit.attributes:
		attrs.append(attr)
		names.append(attr.attribute.name)
		
		# TODO, find a better way to do this
		# Done this way right now because you can only pass strings through meta tags
		# This also assumes a hard cap of max 4 attributes for a troop
		if count == 0:
			actl_ret += "\n[url=0]%s[/url]"
		elif count == 1:
			actl_ret += "\n[url=1]%s[/url]"
		elif count == 2:
			actl_ret += "\n[url=2]%s[/url]"
		elif count == 3:
			actl_ret += "\n[url=3]%s[/url]"
		count += 1

	actl_ret += "[/center]"
	actl_ret = actl_ret % names

	set_text(actl_ret)


func _on_meta_clicked(meta):
	var attr = attrs[int(meta)].attribute
	var form_ret: String
	var actl_ret: String
	
	form_ret = "Name:\n%s (%s)\n\nDescription:\n%s"
	actl_ret = form_ret % [attr.name, attr.abbreviation, attr.description]
	
	set_text(actl_ret)
