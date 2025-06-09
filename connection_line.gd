extends Node2D

var start_card = null
var end_card = null
var line_color = Color.RED
var line_width = 5.0

enum ConnectionType {
	CONTRADICTION,  # Red
	ALLIANCE,      # Blue  
	MOTIVE        # Yellow
}

func _ready():
	set_process(true)
	z_index = -1  # Behind everything

func setup(from_card, to_card, type: int = 0):
	start_card = from_card
	end_card = to_card
	
	match type:
		0: # CONTRADICTION
			line_color = Color.RED
		1: # ALLIANCE
			line_color = Color.BLUE
		2: # MOTIVE
			line_color = Color.YELLOW
	
	queue_redraw()  # Force a redraw

func _draw():
	if start_card and end_card:
		var start_pos = start_card.global_position + start_card.size / 2
		var end_pos = end_card.global_position + end_card.size / 2
		
		# Convert to local coordinates
		var local_start = to_local(start_pos)
		var local_end = to_local(end_pos)
		
		# Draw the line
		draw_line(local_start, local_end, line_color, line_width)
		
		# Optional: Draw small circles at endpoints for visual confirmation
		draw_circle(local_start, 8, line_color)
		draw_circle(local_end, 8, line_color)

func _process(_delta):
	if start_card and end_card:
		queue_redraw()  # Continuously update the line position
