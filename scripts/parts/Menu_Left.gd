extends Panel

# BTN_Config toggles main menu items to add/remove/edit each button
# BTN_Config also toggles editting the content of each button

# BTN_Config ENABLE show button to save content after editing.
# BTN_Config DISABLE each button adds text to the editor on caret position.

@onready var menu_container: VBoxContainer = %MainMenu
@onready var menu_item: PackedScene = preload("res://scenes/parts/Menu_Item.tscn");

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

			new_item.button_text = item;

			if (placeholder_menu[item] is String):
				new_item.button_content = placeholder_menu[item];

			if (placeholder_menu[item] is Dictionary):
				new_item.type = MenuItem.Type.HAS_SUBMENU;
				for subitem in placeholder_menu[item]:
					new_item.submenu_add_item(subitem, placeholder_menu[item][subitem]);

			new_item.finish();

# Event
