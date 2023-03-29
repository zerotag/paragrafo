class_name Tooltip extends PanelContainer

@onready var head_node: Label = %Header
@onready var body_node: Label = %Body
@onready var foot_node: Label = %Footer
@onready var sep1_node: HSeparator = %Separator1
@onready var sep2_node: HSeparator = %Separator2

# Override
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var pos = get_viewport().get_mouse_position() + Vector2(10, 10);
	set_global_position(pos);

# Helper
func set_data(header: String, body: String, footer: String) -> void:
	head_node.text = header;
	if (header.is_empty()):
		head_node.hide();
		sep1_node.hide();
	else:
		head_node.show();
		sep1_node.show();

	body_node.text = body;
	if (body.is_empty()):
		body_node.hide();
		sep2_node.hide();
	else:
		body_node.show();

	foot_node.text = footer;
	if (footer.is_empty()):
		foot_node.hide();
		sep2_node.hide();
	else:
		foot_node.show();
		sep2_node.show();

	reset_size();

# Event
