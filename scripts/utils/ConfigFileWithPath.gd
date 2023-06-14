class_name ConfigFileWithPath extends ConfigFile

var fullpath : String;

# Override
func _init(path: String) -> void:
	self.fullpath = path;
