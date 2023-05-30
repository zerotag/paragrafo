class_name Modal extends PanelContainer

# Nodes
@onready var form: GridContainer = %FormGrid;
@onready var input_group : Dictionary = {
	"label": Label,
	"input": TextEdit,
};

# Data
var inputs : Dictionary = {};

# Override
func _ready() -> void:
	_subscribe_to_events();
	self.hide();

# Helper
func clear_form() -> void:
	for c in form.get_children():
		c.queue_free();

func create_group(label_name: String) -> void:
	var group = {
		"label": input_group.label.new() as Label,
		"input": input_group.input.new() as TextEdit,
	};

	group.label.text = label_name;
	group.input.custom_minimum_size = Vector2(200, 0);
	inputs[label_name] = group.input;
	_add_group_to_form(group);

# Internal
func _add_group_to_form(group: Dictionary) -> void:
	if (group.label && group.input):
		form.add_child(group.label);
		form.add_child(group.input);

func _subscribe_to_events() -> void:
	EventBus.MENU_LEFT_CONFIG_BUTTON.connect(
		func(button: ButtonWithMetadata):
			# I get the instance of the button
			# This is the event being triggered, this need to configure the form
			# And connect the save button to the saving event

			create_group(button.text);
			create_group(button.content);

			self.show();
	);
	pass

# Event
func _on_close_pressed() -> void:
	self.hide();

func _on_self_hide() -> void:
	clear_form();
