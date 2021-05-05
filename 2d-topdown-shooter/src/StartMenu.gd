extends Control

func _ready():
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/BarlowCondensed-Bold.ttf")
	dynamic_font.size = 40
	$Label.set("custom_fonts/font", dynamic_font)
