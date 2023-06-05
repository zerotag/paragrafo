class_name MenuItem extends VBoxContainer

signal SUBMENU_VISIBILITY(state: bool);
signal SUBMENU_TOGGLE();

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

var state : State = State.SUBMENU_CLOSED;

# Override
func _ready() -> void:
	for c in sub_container.get_children():
		c.queue_free();
	submenu_close();
	_subscribe_to_events();

# Helper
func finish_as_pure(label: String, content: String) -> void:
	button.text = label;
	button.content = content;
	button.icon = icons.editor.text.add;
	button.finish();

func finish_as_submenu(label: String) -> void:
	button.text = label;
	button.icon = icons.menu.open;
	button.TYPE = ButtonWithMetadata.Type.HAS_SUBMENU;
	button.finish(self);

func submenu_add_item(label_name: String, metadata: String) -> void:
	var sub_button = ButtonWithMetadata.new();
	sub_button.text = label_name;
	sub_button.content = metadata;
	sub_button.icon = icons.editor.text.add;
	sub_button.alignment = HORIZONTAL_ALIGNMENT_LEFT;
	sub_button.add_theme_constant_override('h_separation', 10);
	sub_button.finish();
	sub_container.add_child(sub_button);

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

# Internals
func _subscribe_to_events() -> void:
	self.SUBMENU_TOGGLE.connect(submenu_toggle);
	self.SUBMENU_VISIBILITY.connect(
		func(open: bool):
			submenu_open() if open else submenu_close();
	);
