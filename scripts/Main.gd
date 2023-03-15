extends Control

@onready var buttons := {
	"button1": %Button1 as Button,
	"button2": %Button2 as Button,
	"button3": %Button3 as Button,
}

@onready var editor : TextEdit = %Editor;
@onready var render : RichTextLabel = %Render;

# Override
func _ready():
	pass

# Helpers
func add_bbcode_to_selection(bbcode: String) -> void:
	var hasSelect = editor.has_selection();

	if (hasSelect):

		editor.grab_focus();
#
		var selection = {
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

		editor.select(selection.line.from, selection.column.from, selection.line.from, selection.line.to);
		editor.remove_text(selection.line.from, selection.column.from, selection.line.to, selection.column.to);
		editor.deselect(0);
		editor.set_caret_line(selection.line.from);
		editor.set_caret_column(selection.column.from);
		editor.insert_text_at_caret("[%s]%s[/%s]" % [bbcode, selection.text, bbcode], 0);

# Events
func _on_editor_text_changed() -> void:
	render.text = editor.text

func _on_editor_format_pressed(bbcode: String) -> void:
	add_bbcode_to_selection(bbcode);
