extends PlaceholderDB

const STORAGE: Dictionary = STORAGE_PLACEHOLDER;
const RELATION: Dictionary = RELATION_PLACEHOLDER;

# Override
func _ready() -> void:
#	# Non Invalid ID
#	print(get_item(StorageType.PERSON, 20));
#	print(get_item(StorageType.LITIGATION, 405));
#	print(get_item(StorageType.DOCUMENT, 5));
#
#	# Invalid ID
#	print(get_item(StorageType.PERSON, 21));
#	print(get_item(StorageType.LITIGATION, 406));
#	print(get_item(StorageType.DOCUMENT, 99));

	pass

# Helper
func get_item(type: StorageType, id: int) -> Dictionary:
	var item = {};
	if (STORAGE[type].has(id)):
		item = STORAGE[type][id];
	else:
		item = INVALID_ITEM;
	return item;

func get_litigations_from_person(id: int) -> Dictionary:
	var person = get_item(StorageType.PERSON, id);
	if (!person.code.is_empty()):
		# Get all relations with the person's ID
		# Get all litigations from relations
		pass
	return {};
