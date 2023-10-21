extends Node2D

var image
var should_update_canvas = false
var drawing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	create_image()
	update_texture()
	$Sprite.offset = Vector2(image.get_width() / 2, image.get_height() / 2)


func create_image():
	image = Image.new()
	image.create(500, 500, false, Image.FORMAT_RGBA8)	
	image.fill(Color.WHITE)
	
func update_texture():
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	$Sprite.set_texture(texture)
	should_update_canvas = false

func _input(event):
	if event is InputEventMouseButton:
		drawing = event.pressed
		
	if event is InputEventMouseMotion and drawing:
		image.lock()

		image.set_pixel(event.position.x, event.position.y, Color.BLACK)
		should_update_canvas = true
			
		image.unlock()

func _process(delta):	
	if should_update_canvas:
		update_texture()	
