class_name MenuItem extends VBoxContainer

enum State {
	PURE_BUTTON,
	HAS_SUBMENU,
}

@onready var button: ButtonWithMetadata = %Button as ButtonWithMetadata
@onready var submenu: PanelContainer = %Submenu
@onready var sub_container: VBoxContainer = %VBC

var type : State = State.PURE_BUTTON;
var button_text : String = "<menu_item_label>";
var button_content : String = "<menu_item_content>";

# Override
func _ready() -> void:
	for c in sub_container.get_children():
		c.queue_free();
	submenu.hide();

# Helper
func finish() -> void:
	button.text = button_text;

	match type:
		State.PURE_BUTTON:
			button.content = button_content;
			button.pressed.connect(
				func():
					print(button.content);
			);

		State.HAS_SUBMENU:
			button.pressed.connect(
				func():
					submenu.visible = !submenu.visible;
			)

func submenu_add_item(label_name: String, metadata: String) -> void:
	if (type == State.PURE_BUTTON):
		return;

	var new_button = ButtonWithMetadata.new();
	new_button.text = label_name;
	new_button.content = metadata;
	new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT;
	new_button.pressed.connect(
		func():
			EventBus.action_editor_insert.emit(new_button.content);
	);
	sub_container.add_child(new_button);

# Event
