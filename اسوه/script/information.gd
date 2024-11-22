extends PopupPanel
signal create(data:Dictionary)
signal update(data:Dictionary, id:int)
signal delete(id:int)
@export_enum("آپدیت", "ایجاد") var _mode = 0
var data = {
	"name": "",
	"writer":"",
	"link":"",
	"img_refrence":"",
	"description":""
}
var id = 0
# Called when the node enters the scene tree for the first time.
func _ready():

	match _mode:
		0:
			%BoxContainer7.show()
		1:
			%BoxContainer6.show()
func reset():
	data = {
	"name": "",
	"writer":"",
	"link":"",
	"img_refrence":"",
	"description":""
	}
	set_data()
	%TextureButton.texture_normal = load("res://sprite/add_btn.png")
func _on_texture_button_pressed():
	$PopupPanel.popup_centered()


func _on_create_pressed():
	emit_signal("create", data)


func _on_update_pressed():
	emit_signal("update", data, id)


func _on_delete_pressed():
	emit_signal("delete", id)


func _on_text_edit_text_changed():
	data["description"] = %TextEdit.text


func _on_line_edit_text_changed(new_text, _name):
	data[_name] = new_text

func set_data():
	%TextEdit.text = data["description"]
	%LineEdit.text = data["name"]
	%LineEdit2.text = data["writer"]
	%LineEdit3.text = data["link"]
func _on_popup_panel_button_pressed(img, link):
	%TextureButton.texture_normal = img
	data["img_refrence"] = link
