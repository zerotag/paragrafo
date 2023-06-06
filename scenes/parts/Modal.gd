class_name Modal extends PanelContainer

# Nodes
@onready var form: GridContainer = %FormGrid;
@onready var input_group : Dictionary = {
	"label": Label,
	"input": TextEdit,
};

# Data
var source : Variant = null :
	set(varObject):
		if (varObject != null):
			source = varObject;
var inputs : Dictionary = {};

# Override
func _ready() -> void:
	_subscribe_to_events();
	self.hide();

# Helper
func clear_form() -> void:
	for c in form.get_children():
		c.queue_free();

func create_group(
	label_text: String,
	input_field_name: String,
	input_content: String,
	input_type_big: bool = false) -> void:

	var group = {
		"label": input_group.label.new() as Label,
		"input": input_group.input.new() as TextEdit,
	};

	group.label.text = label_text;
	group.input.text = input_content;
	group.label.vertical_alignment = VERTICAL_ALIGNMENT_TOP if input_type_big else VERTICAL_ALIGNMENT_CENTER;
	group.label.size_flags_vertical = Control.SIZE_EXPAND_FILL;
	group.input.custom_minimum_size = Vector2(400, 200) if input_type_big else Vector2(200, 35);
	inputs[input_field_name] = group.input;
	_add_group_to_form(group);

# Internal
func _add_group_to_form(group: Dictionary) -> void:
	if (group.label && group.input):
		form.add_child(group.label);
		form.add_child(group.input);

func _subscribe_to_events() -> void:
	EventBus.MENU_LEFT_CONFIG_BUTTON.connect(
		func(button: ButtonWithMetadata):
			self.source = button;
			create_group("Nome", "text", button.text);
			if (button.TYPE == ButtonWithMetadata.Type.PURE_BUTTON):
				create_group("Conteúdo", "content", button.content, true);
			self.show();
	);

func _save_form_to_source() -> void:
	if (source == null):
		return;

	for key in inputs:
		source[key] = inputs[key].text;

# Event
func _on_close_pressed() -> void:
	self.hide();

func _on_save_pressed() -> void:
	_save_form_to_source();
	self.hide();

func _on_self_hide() -> void:
	clear_form();
