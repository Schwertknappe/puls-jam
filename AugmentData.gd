extends Node
class_name AugmentData

static var AUGMENTS = [
{
	"title": "Grounded",
	"description": "Doppelsprung deaktiviert",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.can_double_jump = false
},
{
	"title": "Anti-Grav",
	"description": "Umgekehrte Schwerkraft",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity *= -1
},
{
	"title": "<-->",
	"description": "<>",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.speed *= 0.5
},
{
	"title": "Kanone geht kaputt",
	"description": "Umgekehrte Schwerkraft",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity *= -1
},
{
	"title": "Kollision mit Wänden",
	"description": "Umgekehrte Schwerkraft",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity *= -1
},
{
	"title": "links rechts laufen kaputt",
	"description": "Umgekehrte Schwerkraft",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity *= -1
},
{
	"title": "Spieler wird sehr schnell",
	"description": "Umgekehrte Schwerkraft",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity *= -1
},
{
	"title": "50% hp",
	"description": "Umgekehrte Schwerkraft",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity *= -1
},
]

static func get_random_augments(count: int) -> Array:
	var shuffled = AUGMENTS.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count - 1)
