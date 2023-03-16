extends Control

var phantomjs: Thread;

# Override
func _ready():
#	test_env();
#	var handler = HTMLHandler.new();
#	var bbcode = handler.convert_to_bbcode();
#	print(bbcode);

	_on_toggle_menu(true, "B_Hide_Menu1", "Menu1")
	_on_toggle_menu(true, "B_Hide_Menu2", "Menu2")

# Helpers
func test_env() -> void:
	if (phantomjs == null):
		phantomjs = Thread.new();

	if (phantomjs != null):
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
