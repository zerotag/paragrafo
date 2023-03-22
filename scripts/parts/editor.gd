class_name Editor extends Control

# Nodes (Ready)
@onready var p_editor: Panel = %P_Editor
@onready var editor : TextEdit = %Editor;
@onready var render : RichTextLabel = %Render;
@onready var actions: HBoxContainer = %Editor_Actions;
@onready var action_spacer: Control = %Editor_Spacer;

# Nodes (PackedScenes)
@onready var tooltipScene: PackedScene = preload("res://scenes/parts/Tooltip.tscn");

# Nodes (Not Ready)
var tooltip: Tooltip;

# Override
func _ready():
	render.text = '\n[center][url="https://google.com/"]Google[/url][/center]';

	if (tooltipScene.can_instantiate()):
		tooltip = tooltipScene.instantiate() as Tooltip;
		tooltip.hide();
		add_child(tooltip);

	add_actions_to_editor();

# Helpers
func add_bbcode_to_selection(bbcode: String) -> void:
	var hasSelect = editor.has_selection();

	if (hasSelect):

		editor.grab_focus();

		var selection: Dictionary = {
			"text": editor.get_selected_text(),
			"line": {
				"from": editor.get_selection_from_line(),
				"to": editor.get_selection_to_line()
			},
			"column": {
				"from": editor.get_selection_from_column(),
				"to": editor.get_selection_to_column()
			}
		};

		if (bbcode == "img"):
			if (!image_exists(selection.text)):
				return;

		editor.select(selection.line.from, selection.column.from, selection.line.from, selection.line.to);
		editor.remove_text(selection.line.from, selection.column.from, selection.line.to, selection.column.to);
		editor.deselect(0);
		editor.set_caret_line(selection.line.from);
		editor.set_caret_column(selection.column.from);
		editor.insert_text_at_caret("[%s]%s[/%s]" % [bbcode, selection.text, bbcode], 0);

func add_actions_to_editor() -> void:
	for c in actions.get_children():
		actions.remove_child(c);

	var tags = TagDatabase.TAGS;
	for t in tags.size():
		var currTag: Dictionary = tags[t];
		var btn: Button = Button.new();
		btn.text = currTag.name;
		btn.set_h_size_flags(SIZE_EXPAND_FILL);
		btn.set_stretch_ratio(0.1);
		btn.connect("pressed",
			func():
				_on_editor_format_pressed(currTag.traw);
		);
		actions.add_child(btn);

	actions.add_child(action_spacer);

func image_exists(path: String) -> bool:
	var isRaw = FileAccess.file_exists(path)
	var isRes = FileAccess.file_exists("res://%s" % [path]);
	var isUse = FileAccess.file_exists("user://%s" % [path]);
	return isRaw || isRes || isUse;

# Events
func _on_editor_text_changed() -> void:
	render.text = editor.text

func _on_editor_format_pressed(bbcode: String) -> void:
	add_bbcode_to_selection(bbcode);

func _on_render_meta_clicked(meta: String) -> void:
	# NOTE: Should be sanitized before opening
	OS.shell_open(meta);

func _on_render_meta_hover_started(meta: String) -> void:
	if (tooltip):
		tooltip.set_data("Destino", meta, "");
		tooltip.show();

func _on_render_meta_hover_ended(_meta: String) -> void:
	if (tooltip):
		tooltip.hide();
