extends Control

signal restart_requested

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	var dimmer := ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0.025, 0.035, 0.07, 0.88)
	dimmer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dimmer)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)

	var panel := PanelContainer.new()
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("17243a")
	panel_style.border_color = Color("f7cc58")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)
	panel_style.set_content_margin_all(28.0)
	panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(panel)

	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 14)
	panel.add_child(content)

	var title := Label.new()
	title.text = "YOU MADE IT!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color("ffe16b"))
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Yay!"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", Color("e4eaff"))
	content.add_child(subtitle)

	var restart_button := Button.new()
	restart_button.text = "Play again  (R)"
	restart_button.pressed.connect(func(): restart_requested.emit())
	content.add_child(restart_button)
	restart_button.call_deferred("grab_focus")
