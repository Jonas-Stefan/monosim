extends HBoxContainer

#This just exists to load in all the chips on startup

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
