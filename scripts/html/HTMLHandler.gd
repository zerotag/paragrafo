class_name HTMLHandler;

var _document: String;

func read_html_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ);
	if file != null:
		_document = file.get_as_text();
		file.close();

func render_on_node(_node: Node) -> void:
	# Code to parse the HTML document and apply styles to the node.
	# This could involve creating a DOM-like data structure, traversing the
	# structure to generate a scene tree, and applying styles to the nodes.
	# Depending on the desired output, this may be a complex task and require
	# additional classes and functions.
	pass

func convert_to_bbcode() -> String:
	var tag_list: Array[Dictionary] = TagDatabase.TAGS;

	var parseRegex = RegEx.new();
	var converted = _document;
	for r in tag_list.size():
		var currTag: Dictionary = tag_list[r];

		parseRegex.clear();
		parseRegex.compile(currTag.regx);

		var parseTags: Array[RegExMatch] = parseRegex.search_all(_document);

		if (parseTags.size() == 0):
			continue;

		var stag: String = parseTags[0].get_string(0);
		var etag: String = "";
		if (parseTags.size() > 1):
			etag = parseTags[1].get_string(0);
		var url: String = parseTags[0].get_string("url");

		if (!stag.is_empty()):
			converted = converted.replace(stag, currTag.sbbt);
		if (!etag.is_empty()):
			converted = converted.replace(etag, currTag.ebbt);
		else:
			converted = "%s%s" % [converted, currTag.ebbt];
		if (!url.is_empty()):
			converted = converted.replace("{url}", url);

	return converted;

func sanitize_html() -> void:
	# Combine all regular expressions into a single one using the OR operator
	var combined_regex = "(%s)" % [
		"<script>.*?</script>",
		"onclick\\s*=\\s*\"[^\"]*\"",
	].reduce(
		func(acc, piece):
			return "%s|%s" % [acc, piece];
	);

	var regex = RegEx.new()
	regex.compile(combined_regex);

	# Search for all matches in the HTML document and remove them
	var matches = regex.search_all(_document);
	for i in range(matches.size() - 1, 0, -1):
		_document = _document.replace(matches[i].string(), "");
