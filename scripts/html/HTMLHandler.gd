class_name HTMLHandler;

var _document: String = '';

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

# NOTE: If HTML Rendering doesn't work, get back to this.
# For now, return empty
func convert_to_bbcode() -> String:
	return "";

	# Define regular expressions for HTML tags that should be converted to BBCode
	var regex_list := [
		["<b>", "[b]"],
		["</b>", "[/b]"],
		["<i>", "[i]"],
		["</i>", "[/i]"],
		["<u>", "[u]"],
		["</u>", "[/u]"],
		['<a\\s+[^>]*href="(?<url>[^"]*)".*?>', "[url={url}]"],
		["</a>", "[/url]"],
		["<img src=\"([^\"]+)\"[^>]*>", "[img]{url}[/img]"],
	];

	# Combine all regular expressions into a single one using the OR operator
	var combined_regex = "(%s)" % regex_list.reduce(
		func(acc, piece):
			return piece[0] if acc == "" else "%s|%s" % [acc, piece[0]];
	, "");

	var regex = RegEx.new();
	regex.compile(combined_regex);

	# Replace all matched HTML tags with their corresponding BBCode
	var matches = regex.search_all(_document);
	var bbcode = _document;
	for i in range(matches.size() -1, -1, -1):
		var currMatch = matches[i];
		var tag = currMatch.get_string(0);
		var url = currMatch.get_string("url");

		# NOTE: BUG... Wrong index access
		var replaceWith = regex_list[i][1];
		bbcode = bbcode.replace(tag, replaceWith);
		if (!url.is_empty()):
			bbcode = bbcode.replace("{url}", url);

#		for j in range(regex_list.size()):
#			var regex_piece = regex_list[j];
#			if tag.match(regex_piece[0]):
#				bbcode = bbcode.replace(tag, regex_piece[1]);
#				break;

	return bbcode;

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
