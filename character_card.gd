extends Control

var is_dragging = false
var drag_offset = Vector2()

# Character data
var character_name = "Unknown"
var character_id = 0

signal card_clicked(card)
signal card_released(card)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	gui_input.connect(_on_gui_input)
	custom_minimum_size = Vector2(150, 200)  # Ensure minimum size
	size = Vector2(150, 200)  # Set actual size

func _draw():
	# Draw our own background if Panel isn't working
	var rect = Rect2(Vector2.ZERO, size)
	
	# Background
	draw_rect(rect, Color("#4a4a4a"))
	
	# Border
	draw_rect(rect, Color.WHITE, false, 2.0)

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_offset = global_position - event.global_position
				emit_signal("card_clicked", self)
				# Move to front
				get_parent().move_child(self, -1)
			else:
				is_dragging = false
				emit_signal("card_released", self)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			_show_context_menu()
	
	elif event is InputEventMouseMotion and is_dragging:
		global_position = event.global_position + drag_offset

func set_character(name: String, id: int):
	character_name = name
	character_id = id
	$CharacterName.text = name

func _show_context_menu():
	print("Right clicked on: ", character_name)
