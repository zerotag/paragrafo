class_name ConfigFileStructure extends Object

var section : String;
var field : String;
var value : Variant;

# Override
func _init(
	structure_section : String,
	structure_field : String,
	structure_value : Variant) -> void:

	self.section = structure_section;
	self.field = structure_field;
	self.value = structure_value;

func get_type() -> String:
	return "ConfigFileStructure";
