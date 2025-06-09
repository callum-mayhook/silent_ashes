extends ColorRect

func _ready():
	print("Background size: ", size)
	print("Background position: ", position)
	print("Parent size: ", get_parent().get_viewport_rect().size)
