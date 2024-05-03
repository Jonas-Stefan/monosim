extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	#load in all the chips
	var dir = DirAccess.open("res://Chips/Chips")
	for file in dir.get_files():
		var newBtn = Button.new()
		newBtn.theme = load("res://UITheme.tres")
		newBtn.set_script(load("res://Scripts/UI/componentBtn.gd"))
		newBtn.name = file.get_file().trim_suffix(".tres")
		newBtn.text = file.get_file().trim_suffix(".tres")
		add_child(newBtn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
