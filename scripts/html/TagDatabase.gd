class_name TagDatabase extends Node

const TAGS: Array[Dictionary] = [
	{
		"name": "Negrito",
		"traw": "b",
		"stag": "<b>",
		"etag": "</b>",
		"sbbt": "[b]",
		"ebbt": "[/b]",
		"regx": "<b>|</b>"
	},
	{
		"name": "Itálico",
		"traw": "i",
		"stag": "<i>",
		"etag": "</i>",
		"sbbt": "[i]",
		"ebbt": "[/i]",
		"regx": '<i>|</i>'
	},
	{
		"name": "Sublinhado",
		"traw": "u",
		"stag": "<u>",
		"etag": "</u>",
		"sbbt": "[u]",
		"ebbt": "[/u]",
		"regx": '<u>|</u>'
	},
	{
		"name": "Centro",
		"traw": "center",
		"stag": "<center>",
		"etag": "</center>",
		"sbbt": "[center]",
		"ebbt": "[/center]",
		"regx": '<center>|</center>'
	},
	{
		"name": "Direita",
		"traw": "right",
		"stag": "<right>",
		"etag": "</right>",
		"sbbt": "[right]",
		"ebbt": "[/right]",
		"regx": '<right>|</right>'
	},
	{
		"name": "Link",
		"traw": "url",
		"stag": "<a>",
		"etag": "</a>",
		"sbbt": "[url={url}]",
		"ebbt": "[/url]",
		"regx": '<a\\s+[^>]*href="(?<url>[^"]*)".*?>|</a>'
	},
	{
		"name": "Imagem",
		"traw": "img",
		"stag": "<img>",
		"etag": "",
		"sbbt": "[img]{url}",
		"ebbt": "[/img]",
		"regx": '<img src=\"(?<url>[^\"]+)\"[^>]*>'
	},
];
