extends GridContainer

@export var character_sprites: Array = []  # List of available character sprite paths
@export var grid_columns: int = 4  # Number of columns in the grid

signal character_selected(index: int, sprite_path: String)  # Emitted when a character is selected

func _ready():
	_generate_grid()

func _generate_grid():
	# Load character sprites into the grid
	for i in range(character_sprites.size()):
		var sprite_path = character_sprites[i]
		var button = TextureButton.new()
		button.texture_normal = load(sprite_path)
		# Bind the index and sprite path to the button's pressed signal
		button.connect("pressed", Callable(_on_character_pressed).bind(i, sprite_path))
		add_child(button)

func _on_character_pressed(index: int, sprite_path: String):
	# Emit signal when a character is selected
	emit_signal("character_selected", index, sprite_path)
