class_name ButtonWithMetadata extends Button

enum Type {
	PURE_BUTTON,
	HAS_SUBMENU,
}

@export_multiline var content: String = "";

# FSMs
var PARENT: MenuItem = null;
var CONFIG_MODE: bool = false;
var TYPE: Type = Type.PURE_BUTTON;

# Helper
func finish(parent: MenuItem = null) -> void:
	PARENT = parent;
	_setup_events();

# Internals
func _set_config_mode(mode: bool) -> void:
	CONFIG_MODE = mode;

func _setup_events() -> void:
	self.pressed.connect(_handle_pressed);
	EventBus.MENU_LEFT_CONFIG_MODE.connect(_set_config_mode);

func _handle_pressed() -> void:
	if CONFIG_MODE:
		EventBus.MENU_LEFT_CONFIG_BUTTON.emit(self);
	else:
		match TYPE:
			Type.PURE_BUTTON:
				EventBus.ACTION_EDITOR_INSERT.emit(content);
			Type.HAS_SUBMENU:
				if (PARENT):
					PARENT.SUBMENU_TOGGLE.emit();
