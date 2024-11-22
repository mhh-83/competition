extends PopupPanel
var images = []
var filter_image = []
var page = 1
var max_page = 1
@onready var number_container = $PanelContainer/VBoxContainer/HBoxContainer2/HBoxContainer
var path = ""
signal button_pressed(img:ImageTexture, link:String)
var url = "https://misaghgame.ir"
# Called when the node enters the scene tree for the first time.
var save_path = "user://data.cfg"
func save(_name, num, path=save_path):
	var confige = ConfigFile.new()
	confige.load(save_path)
	confige.set_value("user", _name, num)
	confige.save(path)
func load_game(_name, defaulte=null, path=save_path):
	var confige = ConfigFile.new()
	confige.load(path)
	return confige.get_value("user", _name, defaulte)
func _ready():
	pass
