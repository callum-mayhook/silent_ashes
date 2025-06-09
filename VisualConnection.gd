extends ColorRect

var start_card = null
var end_card = null

func setup(from_card, to_card, connection_color = Color.RED):
	start_card = from_card
	end_card = to_card
	color = connection_color
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # Don't block mouse clicks
	z_index = -1  # Behind cards
	update_line()

func update_line():
	if !start_card or !end_card:
		return
		
	var start_pos = start_card.global_position + start_card.size / 2
	var end_pos = end_card.global_position + end_card.size / 2
	
	# Calculate distance and angle
	var distance = start_pos.distance_to(end_pos)
	var direction = (end_pos - start_pos).normalized()
	var angle = start_pos.angle_to_point(end_pos)
	
	# Set line properties
	size = Vector2(distance, 5)  # 5 pixels thick
	global_position = start_pos
	rotation = angle
	
	# Offset to center the line on the start point
	position.y -= size.y / 2

func _process(_delta):
	if start_card and end_card:
		update_line()
