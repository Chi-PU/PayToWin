extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.set_physics_process(false)
		_show_win_screen()


func _show_win_screen() -> void:
	var canvas  := CanvasLayer.new()
	var label   := Label.new()

	label.text                = "YOU WON"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 64)
	
	# Add this line to change the color to black
	label.add_theme_color_override("font_color", Color.BLACK)
	
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	canvas.add_child(label)
	get_tree().root.add_child(canvas)
