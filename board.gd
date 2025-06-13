extends Control

const CharacterCard = preload("res://CharacterCard.tscn")

var cards = []
var connections = []
var selected_card = null
var rename_target = null

@onready var rename_dialog: AcceptDialog = $RenameDialog
@onready var rename_line_edit: LineEdit = $RenameDialog/LineEdit

func _ready():
        # Make board fill screen
        anchor_right = 1.0
        anchor_bottom = 1.0

        rename_dialog.get_ok_button().text = "Rename"
        rename_dialog.connect("confirmed", _on_rename_confirmed)
	
	# Create cards
	create_character_card("Elias Varn", Vector2(100, 100))
	create_character_card("Carina Bel", Vector2(300, 100))
	create_character_card("Miro Janek", Vector2(500, 100))
	create_character_card("Lida Kos", Vector2(100, 350))
	create_character_card("Erol Fen", Vector2(300, 350))

func create_character_card(character_name: String, pos: Vector2):
	var card = CharacterCard.instantiate()
	add_child(card)
        card.position = pos
        card.set_character(character_name, cards.size())
        card.card_clicked.connect(_on_card_clicked)
        card.card_released.connect(_on_card_released)
        card.remove_connections.connect(_on_remove_connections)
        card.rename_requested.connect(_on_rename_requested)
        cards.append(card)

func _on_card_clicked(card):
	if selected_card and selected_card != card:
		create_connection(selected_card, card)
		selected_card = null
	else:
		selected_card = card
		print("Selected: ", card.character_name)

func _on_card_released(card):
	pass

func create_connection(from_card, to_card):
	# Check if already connected
	for conn in connections:
		if (conn.from == from_card and conn.to == to_card) or \
		   (conn.from == to_card and conn.to == from_card):
			return
	
	# Create a thin ColorRect to act as a line
	var line = ColorRect.new()
	line.color = Color.RED
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(line)
	move_child(line, 1)  # Put above background but below cards
	
	# Position the line
	_update_line_position(line, from_card, to_card)
	
	# Store the connection
	connections.append({
		"from": from_card,
		"to": to_card,
		"line": line
	})
	
	print("Created line between ", from_card.character_name, " and ", to_card.character_name)

func _update_line_position(line: ColorRect, from_card, to_card):
	var start = from_card.position + from_card.size / 2
	var end = to_card.position + to_card.size / 2
	
	# Calculate line properties
	var distance = start.distance_to(end)
	var angle = start.angle_to_point(end)
	
	# Set line transform
	line.position = start
	line.size = Vector2(distance, 5)  # 5 pixels thick
	line.rotation = angle
	
	# Adjust position to center the line on its thickness
	var offset = Vector2(0, -2.5).rotated(angle)
	line.position += offset

func _process(_delta):
        # Update all line positions when cards move
        for conn in connections:
                if is_instance_valid(conn.from) and is_instance_valid(conn.to):
                        _update_line_position(conn.line, conn.from, conn.to)

func _on_remove_connections(card):
        var to_remove = []
        for conn in connections:
                if conn.from == card or conn.to == card:
                        if is_instance_valid(conn.line):
                                conn.line.queue_free()
                        to_remove.append(conn)
        for rem in to_remove:
                connections.erase(rem)

func _on_rename_requested(card):
        rename_target = card
        rename_line_edit.text = card.character_name
        rename_dialog.popup_centered(Vector2(200, 80))

func _on_rename_confirmed():
        if rename_target:
                rename_target.set_character(rename_line_edit.text, rename_target.character_id)
                rename_target = null
