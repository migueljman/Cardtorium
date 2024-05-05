extends Node2D

var troop: Troop
var troop_sprite: Sprite2D
var TEXT: Label

## Colors for various players
var player_colors: Array[Color] = [Color(0.7, 0.7, 1), Color(1, 0.7, 0.7)]

# Called when the node enters the scene tree for the first time.
func prepare_for_render(troop_to_render: Troop, game: Game):
	var sprite = $Sprite
	troop_sprite = sprite
	TEXT = $HP
	self.troop = troop_to_render
	var texture: Texture2D = load("res://Assets/Troop Sprites/idle_{0}.png".format({0: troop.id}))
	if texture != null:
		sprite.texture = texture
	if troop.owned_by == 0:
			sprite.flip_h = true
	
	game.troop_moved.connect(self.on_troop_moved)
	game.unit_removed.connect(self.on_troop_died)
	game.troop_toggle_act.connect(self.on_troop_toggle_act)
	game.turn_ended.connect(self.on_turn_ended)
	troop.damaged.connect(on_damaged)
	TEXT.text = "%d/%d" % [troop.health, troop.base_stats.health]
	# If the troop cannot move on turn zero, it is greyed out
	on_troop_toggle_act(troop)

## Changes color of the sprite depending on whose turn it is.
func on_turn_ended(_prev: int, player: Player):
	if player.local_id == troop.owned_by:
		troop_sprite.modulate = Color(1, 1, 1)
	else:
		troop_sprite.modulate = player_colors[player.local_id]

## If the troop can no longer move, grey it out.
func on_troop_toggle_act(_troop: Troop):
	if _troop != self.troop:
		return
	if troop.can_act or troop.can_move or troop.can_attack:
		troop_sprite.modulate = Color(1, 1, 1)
	else:
		troop_sprite.modulate = Color(0.5, 0.5, 0.5)

## Called when a troop is moved
func on_troop_moved(_troop: Troop, path: Array):
	if _troop != self.troop:
		return
	position = 64 * path[-1]

## Called when a troop dies
func on_troop_died(unit: Unit):
	if unit is Troop and unit == troop:
		self.queue_free()

## Called when a troop takes damage
func on_damaged():
	TEXT.text = "%d/%d" % [troop.health, troop.base_stats.health]
