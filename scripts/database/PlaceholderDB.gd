class_name PlaceholderDB extends Node

# Databases
const STORAGE_PLACEHOLDER: Dictionary = {
	StorageType.PERSON: {
		10: {
			"name": "João",
			"code": "321.654.987-99",
			"type": PersonType.CPF,
			"mail": "joao@domain.com",
		},

		14: {
			"name": "Maria",
			"code": "123.456.789-00",
			"type": PersonType.CPF,
			"mail": "maria@domain.com",
		},

		20: {
			"name": "Carlos",
			"code": "123.654.789-09",
			"type": PersonType.CPF,
			"mail": "carlos@domain.com",
		},

		33: {
			"name": "Microsoft",
			"code": "10.555.159/0001-99",
			"type": PersonType.CNPJ,
			"mail": "legal@microsoft.com",
		},
	},

	StorageType.LITIGATION: {
		103: {
			"code": "10000.4030/14/14/14",
			"location": LitigationLocation.SC,
			"area": LitigationType.CIVIL,
			"sphere": LitigationSphere.STATE,
		},

		405: {
			"code": "2000.4343434/1515151/1",
			"location": LitigationLocation.SC,
			"area": LitigationType.CIVIL,
			"sphere": LitigationSphere.FEDERAL,
		},

		410: {
			"code": "45-57980.359173/555",
			"location": LitigationLocation.RO,
			"area": LitigationType.CIVIL,
			"sphere": LitigationSphere.STATE,
		},

		610: {
			"code": "2000.434312/24551/10",
			"location": LitigationLocation.SP,
			"area": LitigationType.CRIMINAL,
			"sphere": LitigationSphere.FEDERAL,
		},
	},

	StorageType.DOCUMENT: {
		1: {
			"litigation": 405,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		2: {
			"litigation": 103,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		3: {
			"litigation": 610,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		4: {
			"litigation": 410,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		5: {
			"litigation": 103,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		6: {
			"litigation": 103,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		7: {
			"litigation": 103,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},

		8: {
			"litigation": 103,
			"title": "Lorem Ipsum Dolor",
			"content": "[b]Lorem[/b] [url=\"https://google.com\"]Google[/url] dolor!"
		},
	},
};

const RELATION_PLACEHOLDER: Dictionary = {
	RelationType.PERSON_LITIGATION: [
		[20, 410],
		[20, 103],
		[10, 103],
	],

	RelationType.LITIGATION_LITIGATION: [
		[103, 405],
		[405, 610],
	],
};

const INVALID_ITEM: Dictionary = {
	"name": "Not Found",
	"code": Error.INVALID_ITEM,
};

# Enumerations
enum Error {
	INVALID_ITEM = 404,
}

enum StorageType {
	PERSON,
	LITIGATION,
	DOCUMENT,
}

enum RelationType {
	PERSON_LITIGATION,
	LITIGATION_LITIGATION,
}

enum PersonType {
	CPF,
	CNPJ,
}

enum LitigationSphere {
	STATE,
	FEDERAL,
}

enum LitigationType {
	CIVIL,
	CRIMINAL,
}

enum LitigationLocation {
	SC,
	SP,
	RO,
}
