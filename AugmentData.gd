extends Node
class_name AugmentData

static var AUGMENTS = [
{
	"title": "Stay Low",
	"description": "Double Jump disabled",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.double_jump_enabled = false
},
{
	"title": "Anti-Grav",
	"description": "Reversed Gravity",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.gravity_modifier = -1.0
},
{
	"title": "<-->",
	"description": "Left is right?",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.mirror_input = true
},
{
	"title": "Out of fire",
	"description": "Pistol disabled",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.can_shoot = false
},
{
	"title": "Nothing can stop me!",
	"description": "Collisions with walls disabled",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.collides_with_walls = false
},
{
	"title": "No looking back",
	"description": "Cannot run left",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.can_walk_left = false
},
{
	"title": "Out of my way!",
	"description": "Run faster",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.SPEED *= 1.5 
},
{
	"title": "Here comes the snail",
	"description": "Run slower",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.SPEED *= 0.5 
},
{
	"title": "Grounded",
	"description": "Jumping disabled",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.jump_enabled = false
},
{
	"title": "A Wall is a wall",
	"description": "Walljump disabled",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.walljump_enabled = false
},
{
	"title": "Feeling tipsy",
	"description": "Jumping adds horizontal direction",
	"icon": preload("res://assets/sprites/Walk.png"),
	"apply": func(p): p.randomize_horizontal_jump_direction = true
},
]

static func get_random_augments(count: int) -> Array:
	var shuffled = AUGMENTS.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count - 1)
