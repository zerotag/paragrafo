extends Panel

enum State {
	CONFIG_MODE_ON,
	CONFIG_MODE_OFF,
}

@onready var menu_container: VBoxContainer = %MainMenu
@onready var menu_config: Button = %Config
@onready var menu_item: PackedScene = preload("res://scenes/parts/Menu_Item.tscn");

var state : State = State.CONFIG_MODE_OFF;

var placeholder_menu = {
	"Endereçamento": {
		"1ª Instância": "[center][color=#5555FF]1ª Instância[/color][/center]",
		"2ª Instância": "2ª Instância",
		"Instância Superior": "Instância Superior",
		"Autoridade\nAdministrativa": "Autoridade Administrativa",
	},
	"Requerente": "requerente_content",
	"Peça Técnica": "peça_tecnica_content",
	"Requerido": "requerido_content",
	"Causa de Pedir": {
		"Narrativa Fática": "Narrativa Fática",
		"Direito": "Direito",
	},
	"Requerimentos": {
		"Data e Assinatura": "Data e Assinatura",
		"Anexos": "Anexos",
	}
}

# Override
func _ready() -> void:
	setup_menu_items();

# Helper
func setup_menu_items() -> void:
	for item in placeholder_menu:

		if (menu_item.can_instantiate()):
			var new_item = menu_item.instantiate() as MenuItem;
			menu_container.add_child(new_item);

			if (placeholder_menu[item] is String):
				new_item.finish_as_pure(item, placeholder_menu[item]);

			if (placeholder_menu[item] is Dictionary):
				for subitem in placeholder_menu[item]:
					new_item.submenu_add_item(subitem, placeholder_menu[item][subitem]);
				new_item.finish_as_submenu(item);

func config_mode_on() -> void:
	state = State.CONFIG_MODE_ON;

func config_mode_off() -> void:
	state = State.CONFIG_MODE_OFF;

# Event
func _on_config_toggled(btn_state: bool) -> void:
	config_mode_off() if btn_state else config_mode_on();
	EventBus.MENU_LEFT_CONFIG_MODE.emit(state);
