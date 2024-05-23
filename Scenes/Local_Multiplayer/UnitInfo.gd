extends Popup


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_game_display_unit_info():
	visible = true

func _on_game_hide_unit_info():
	visible = false
