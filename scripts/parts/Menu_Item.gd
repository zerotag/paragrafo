class_name MenuItem extends VBoxContainer

enum Type {
	PURE_BUTTON,
	HAS_SUBMENU,
}

enum State {
	SUBMENU_OPENED,
	SUBMENU_CLOSED,
}

@onready var button : ButtonWithMetadata = %Button as ButtonWithMetadata;
@onready var submenu : PanelContainer = %Submenu;
@onready var sub_container : VBoxContainer = %VBC;

@onready var icons : Dictionary = {
	"menu": {
		"open": preload("res://assets/imgs/32/menu.open.png") as Texture2D,
		"close": preload("res://assets/imgs/32/menu.close.png") as Texture2D,
	},
	"editor": {
		"text": {
			"add": preload("res://assets/imgs/32/editor.add.text.png") as Texture2D,
		}
	}
};

var type : Type = Type.PURE_BUTTON;
var state : State = State.SUBMENU_CLOSED;
var button_text : String = "<menu_item_label>";
var button_content : String = "<menu_item_content>";

# Override
func _ready() -> void:
	for c in sub_container.get_children():
		c.queue_free();
	submenu_close();

# Helper
func finish() -> void:
	button.text = button_text;

	match type:
		Type.PURE_BUTTON:
			button.content = button_content;
			button.icon = icons.editor.text.add;
			button.pressed.connect(
				func():
					trigger_editor_event(button.content);
			);

		Type.HAS_SUBMENU:
			button.pressed.connect(
				func():
					submenu_toggle();
			)

func submenu_add_item(label_name: String, metadata: String) -> void:
	if (type == Type.PURE_BUTTON):
		return;

	var new_button = ButtonWithMetadata.new();
	new_button.text = label_name;
	new_button.content = metadata;
	new_button.icon = icons.editor.text.add;
	new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT;
	new_button.add_theme_constant_override('h_separation', 10);
	new_button.pressed.connect(
		func():
			trigger_editor_event(new_button.content);
	);
	sub_container.add_child(new_button);

func submenu_toggle() -> void:
	match state:
		State.SUBMENU_OPENED:
			submenu_close();
		State.SUBMENU_CLOSED:
			submenu_open();

func submenu_open() -> void:
	self.state = State.SUBMENU_OPENED;
	self.button.icon = icons.menu.close;
	self.submenu.show();

func submenu_close() -> void:
	self.state = State.SUBMENU_CLOSED;
	self.button.icon = icons.menu.open;
	self.submenu.hide();

# Event
func trigger_editor_event(content: String) -> void:
	EventBus.action_editor_insert.emit(content);
