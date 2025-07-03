extends Node

@export var base_path := "user://image"
var count := 0

@export_node_path var texture_source_path := NodePath("../CanvasLayer/TextureRect")
@onready var texture_source := get_node(texture_source_path)

@export var texture_property := "texture"

func save():
	var texture:Texture2D = texture_source.get(texture_property)
	
	if !(texture is Texture2D):
		printerr("couldn't find texture ", texture_property, " in ", texture_source, "!")
		return
	
	var image := texture.get_image()
	image.save_png(base_path + str(count) + ".png")
	print("saved image to ", base_path + str(count) + ".png")
	
	count += 1
