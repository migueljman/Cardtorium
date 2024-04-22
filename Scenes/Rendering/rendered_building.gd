extends Node2D

## The building to render
var building: Building

## Sets up the building to be rendered
func prepare_for_render(_building: Building, game: Game):
	building = _building
	var sprite = $Sprite
	var texture: Texture2D = load("res://Assets/Building Sprites/idle_{0}.png".format({0: building.base_stats.id}))
	if texture != null:
		sprite.texture = texture
	# Connects signals
	game.unit_removed.connect(on_unit_removed)


## Called when the building is removed from the board
func on_unit_removed(unit: Unit):
	if unit is Building and unit == building:
		queue_free()