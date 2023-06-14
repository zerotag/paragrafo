class_name Main extends Control

# WinRAR for compressed files
#command: "rar a -ep1 -r <destination> <source>"

var phantomjs: Thread;

# Override
func _ready():
#	_on_toggle_menu(true, "B_Hide_Menu1", "Menu1");
	_on_toggle_menu(true, "B_Hide_Menu2", "Menu2");
#	_test_database();

# Helpers
func test_env() -> void:
	phantomjs = Thread.new();
	phantomjs.start(phantomjs_run);

func phantomjs_run() -> void:
	var res: String = to_global("res://");
	var paths = {
		"phantomjs": "%s%s/%s" % [res, "bin", "phantomjs.exe"],
		"config": "%s%s/%s" % [res, "bin", "phantomjs.config.js"],
		"input": "%s%s/%s" % [res, "dist", "input.html"],
		"output": "%s%s/%s" % [res, "dist", "output.pdf"]
	};

	var args := [
		'"%s"' % [paths.config],
		'"%s"' % [paths.input],
		'"%s"' % [paths.output],
	];

	var result := OS.execute(paths.phantomjs, args);
	if result != OK:
		print("Failed to execute command. [1]");
	print("[Godot][phantomJS] PDF Generated at <%s>" % [paths.output]);

	result = OS.shell_open(paths.output);
	if result != OK:
		print("Failed to execute command. [2]");
	print("[Godot][Shell] Opened file at <%s>" % [paths.output]);

func to_global(path: String) -> String:
	return ProjectSettings.globalize_path(path);

func toggle_menu(which: String, state: bool) -> void:
	which = which;
	var menu = get_node("%" + which) as Panel;
	if (!menu):
		return;
	menu.visible = state;

func toggle_button(which: String, state: bool) -> void:
	var myself = get_node("%" + which) as Button;
	myself.set_pressed_no_signal(state);

	myself.text = "<" if myself.text == ">" else ">";

# Events
func _on_toggle_menu(button_pressed: bool, button_name: String, menu: String) -> void:
	toggle_button(button_name, button_pressed);
	toggle_menu(menu, !button_pressed);

# DEBUG
func _test_database() -> void:
	var sect = "v.000.001.alpha";
	var fileID = 10;
	var data = {
		"id": fileID,
		"nome": "João",
		"numero": "XXX.XXX.XXX-XX",
		"tipo": "cpf",
		"email": "meu@dominio.com",
	};

	var batch = [];
	for k in data:
		batch.append(ConfigFileStructure.new(sect, k, data[k]));

	Database.insert_update_batch("person", fileID, batch);
