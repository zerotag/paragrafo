extends PlaceholderDB

const STORAGE: Dictionary = STORAGE_PLACEHOLDER;
const RELATION: Dictionary = RELATION_PLACEHOLDER;

# Override
func _ready() -> void:
#	# Non Invalid ID
	print("<Dictionary>");
	print(get_item(StorageType.PERSON, 20));
	print(get_item(StorageType.LITIGATION, 405));
	print(get_item(StorageType.DOCUMENT, 5));

	print("\n%s" % "<Array[Dictionary]>");
	print(get_litigations_from_person(20));
	print(get_litigations_from_litigation(405));

#	# Invalid ID
	print("\n%s" % "<Dictionary>");
	print(get_item(StorageType.PERSON, 21));
	print(get_item(StorageType.LITIGATION, 406));
	print(get_item(StorageType.DOCUMENT, 99));

	print("\n%s" % "<Array[Dictionary]>");
	print(get_litigations_from_person(21));
	print(get_documents_from_litigation(406));
	print(get_litigations_from_litigation(406));

# Helper
func get_item(type: StorageType, id: int) -> Dictionary:
	var item = {};
	if (STORAGE[type].has(id)):
		item = STORAGE[type][id];
	else:
		item = INVALID_ITEM;
	return item;

func get_related(source_type: StorageType, related_type: StorageType, relation_type: RelationType, source_id: int) -> Array[Dictionary]:

	var item = get_item(source_type, source_id);
	var related: Array[Dictionary] = [];
	if (!item.code.is_empty()):

		# SELECT * FROM relation TABLE
		for rel in RELATION[relation_type]:

			# Sanity check if there are only 2 values in this array
			# And check if RELATION includes the source's ID
			if (rel.size() == 2 && rel.has(source_id)):

				var FIXED_METHOD = false;
				if (FIXED_METHOD):
					# Either assume [0] is source_id and [1] is related_id
					# And use it with direct access

					## NOTE: Using this method on relation of type LITIGATION_LITIGATION
					## Will introduce a bug, which it will return the source item as well
					var related_item = get_item(related_type, rel[1]);
					related.append(related_item);
				else:
					# Or duplicate the current array, to delete the random positioned source_id
					# And use the remaining value as related_id
					var related_item = rel.duplicate();
					related_item.erase(source_id);
					related_item = get_item(related_type, rel[0]);
					related.append(related_item);

	else:
		related.append(INVALID_ITEM);

	return related;

func get_documents_from_litigation(litigation_id: int) -> Array[Dictionary]:
	var litigation = get_item(StorageType.LITIGATION, litigation_id);
	var documents: Array[Dictionary] = [];

	if (!litigation.code.is_empty()):

		var storage_docs = STORAGE[StorageType.DOCUMENT];
		for i in storage_docs:
			if (storage_docs[i].litigation == litigation_id):
				documents.append(storage_docs[i]);

	else:
		documents.append(INVALID_ITEM);

	return documents;

# Aliases
func get_person(person_id: int) -> Dictionary:
	return get_item(StorageType.PERSON, person_id);

func get_litigation(litigation_id: int) -> Dictionary:
	return get_item(StorageType.LITIGATION, litigation_id);

func get_document(document_id: int) -> Dictionary:
	return get_item(StorageType.DOCUMENT, document_id);

func get_litigations_from_person(person_id: int) -> Array[Dictionary]:
	return get_related(StorageType.PERSON, StorageType.LITIGATION, RelationType.PERSON_LITIGATION, person_id);

func get_litigations_from_litigation(litigation_id: int) -> Array[Dictionary]:
	return get_related(StorageType.LITIGATION, StorageType.LITIGATION, RelationType.LITIGATION_LITIGATION, litigation_id);
