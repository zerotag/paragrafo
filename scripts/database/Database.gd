class_name Database extends Node

const STRUCTURE : Dictionary = {
	"schema": {
		"Endereçamento": {
			"1ª Instância": "[center][color=#5555FF]1ª Instância[/color][/center]",
			"2ª Instância": "[center][color=#5555FF]2ª Instância[/color][/center]",
			"Instância Superior": "[center][color=#5555FF]Instância Superior[/color][/center]",
			"Autoridade\nAdministrativa": "[center][color=#5555FF]Autoridade Administrativa[/color][/center]",
		},
		"Requerente": "[center][color=#5555FF]Requerente[/color][/center]",
		"Peça Técnica": "[center][color=#5555FF]Peça Técnica[/color][/center]",
		"Requerido": "[center][color=#5555FF]Requerido[/color][/center]",
		"Causa de Pedir": {
			"Narrativa Fática": "[center][color=#5555FF]Narrativa Fática[/color][/center]",
			"Direito": "[center][color=#5555FF]Direito[/color][/center]",
		},
		"Requerimentos": {
			"Data e Assinatura": "[center][color=#5555FF]Data e Assinatura[/color][/center]",
			"Anexos": "[center][color=#5555FF]Anexos[/color][/center]",
		}
	},

	"storage": [
		"person",
		"litigation",
		"document"
	],

	"relation": [
		"person_litigation",
		"litigation_litigation"
	],
};

# Static

## Accepts only ConfigFileStructure types in array
static func insert_update_batch(
	where: String,
	file: Variant,
	batch: Array) -> bool:

	var err = false;
	for o in batch:
		if (o is ConfigFileStructure):
			err = true if !insert_update(where, file, o) else err;
	return !err;

## Return success or fail
static func insert_update(
	where: String,
	file: Variant,
	object: ConfigFileStructure) -> bool:

	# Sanity Check
	if (!_storage_exists(where)): return false;

	file = str(file) as String;

	# CFG File Configuration
	var cfg = _get_or_create_cfg_file(where, file);
	cfg.set_value(object.section, object.field, object.value);
	return _save_cfg_file(cfg);

# Internal
static func _storage_exists(
	where: String) -> bool:

	return STRUCTURE.storage.has(where);

static func _key_exists(
	where: String,
	key: String) -> bool:

	return FileAccess.file_exists(_get_file_path(where, key));

# Internal (FILE)
static func _get_or_create_cfg_file(
	where: String,
	key: String) -> ConfigFileWithPath:

	if (!DirAccess.dir_exists_absolute(_get_dir_path(where))):
		DirAccess.make_dir_recursive_absolute(_get_dir_path(where));

	var path = _get_file_path(where, key);
	var cfg = ConfigFileWithPath.new(path);

	cfg.load(cfg.fullpath) if _key_exists(where, key) else cfg.save(cfg.fullpath);

	return cfg;

static func _get_dir_path(
	where: String) -> String:

	return "%s/%s" % ["user://database", where];

static func _get_file_path(
	where: String, key: String) -> String:

	return "%s/%s.%s" % [_get_dir_path(where), key, "ini"];

static func _save_cfg_file(
	file: ConfigFileWithPath) -> bool:

	return true if file.save(file.fullpath) == OK else false;
