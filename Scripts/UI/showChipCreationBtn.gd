extends Button

@onready var chipCreationScreen: CanvasLayer = get_tree().get_root().get_node("root").get_node("chipCreationScreen")

func _ready():
	self.pressed.connect(_on_create_chip_button_pressed)

func _on_create_chip_button_pressed():
	chipCreationScreen.show()
