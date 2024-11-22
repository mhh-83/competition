@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextRotate
extends RichTextEffect

var a = 1
var b = 0
# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [rotate param=2.0]hello[/rotate] in text.
var bbcode = "rotate"


func _process_custom_fx(char_fx):
	var param = char_fx.env.get("range", 1.0)
	var param2 = char_fx.env.get("offset", [0.0, 0.0])
	var freq = char_fx.env.get("freq", 1.0)
	var exp = char_fx.env.get("exp", 0.0)
	var dely = char_fx.env.get("dely", exp)
	if char_fx.elapsed_time == 0:
		a = 1
		b = 0
	if exp > 0:
		if a == 0:
			if int(char_fx.elapsed_time * 100) - int(b * 100) > dely * 100:
				a = 1
		elif int(char_fx.elapsed_time * 100) % int(exp * 100) == 0:
			a = 0
			b = char_fx.elapsed_time
	
	char_fx.offset = Vector2(-param2[0], param2[1])
	char_fx.transform = Transform2D(sin(char_fx.elapsed_time * freq) * param * a, char_fx.transform.get_origin() + Vector2(param2[0], -param2[1]))
	return true
