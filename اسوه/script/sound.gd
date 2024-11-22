extends Node
var button = AudioStreamPlayer2D.new()
var open_panel = AudioStreamPlayer2D.new()
var close_panel = AudioStreamPlayer2D.new()
var back_ground = AudioStreamPlayer2D.new()
var sound_volume = 0
var music_volume = 0
func button_pressed():
	button.play()
func request(url):
	var http = HTTPRequest.new()
	add_child(http)
	http.request(url, ["Authorization: Bearer %s"%UpdateData.token])
	var d = await http.request_completed
	http.queue_free()
	if d[1] == 0:
		return
	return d[3]

func set_sound():
	back_ground.stream = load("res://Audio/BackGround/Illusory-Realm-MP3(chosic.com).mp3")
	add_child(back_ground)
	back_ground.process_mode=Node.PROCESS_MODE_ALWAYS
	back_ground.play()
	if !DirAccess.dir_exists_absolute("user://musics"):
		DirAccess.make_dir_absolute("user://musics")
	var l = await request(UpdateData.protocol+UpdateData.subdomin+"/ListFiles?path=music")
	var l3 = {"files":[]}
	if l:
		l3 = JSON.parse_string(l.get_string_from_utf8())
		var l2 = []
		for file in l3.files:
			l2.append(file.get_file().get_basename()+".mp3str")
		for file in DirAccess.get_files_at("user://musics"):
			if not l2.has(file):
				DirAccess.remove_absolute("user://musics/"+file)
		for file in l3.files:
			if not FileAccess.file_exists("user://musics/"+file.get_file().get_basename()+".mp3str"):
				var m = await request(UpdateData.protocol+UpdateData.subdomin+"/static/files/music/"+file.get_file().uri_encode())
				var s = AudioStreamMP3.new()
				s.data = m
				ResourceSaver.save(s, "user://musics/"+file.get_file().get_basename()+".mp3str")
		
	sound_volume = UpdateData.load_game("sound", 100)
	music_volume = UpdateData.load_game("music", 100)
	set_volume()
	button.autoplay = false
	button.stream = load("res://Audio/click_002.ogg")
	add_child(button)
	open_panel.autoplay = false
	open_panel.stream = load("res://Audio/open_002.ogg")
	add_child(open_panel)
	close_panel.autoplay = false
	close_panel.stream = load("res://Audio/close_002.ogg")
	add_child(close_panel)
	back_ground.autoplay = true
	var stream = AudioStreamRandomizer.new()
	for x in range(DirAccess.get_files_at("user://musics").size()):
		var file = DirAccess.get_files_at("user://musics")[x]
		stream.add_stream(x, load("user://musics/"+file))
	stream.playback_mode = AudioStreamRandomizer.PLAYBACK_RANDOM_NO_REPEATS
	back_ground.stream = stream
	back_ground.play()
	back_ground.finished.connect(func(): back_ground.play())

func connect_signals(object):
	var list = object.get_tree_string().split("\n")
	for t in list:
		var child = object.get_node_or_null(t)
		if child is Button or child is TextureButton:
			child.pressed.connect(button_pressed)
		if child is Panel or child is PopupPanel:
			child.visibility_changed.connect(panel_popup.bind(child))
func set_volume():
	if sound_volume != 0:
		button.attenuation= 20 - (19.9 * (sound_volume / 100.0))
		open_panel.attenuation= 20 - (19.9 * (sound_volume / 100.0))
		close_panel.attenuation= 20 - (19.9 * (sound_volume / 100.0))
		button.max_distance = 4000
		open_panel.max_distance = 4000 
		close_panel.max_distance =4000 
	else:
		button.attenuation= 300
		open_panel.attenuation= 300
		close_panel.attenuation= 300
		button.max_distance = 1
		open_panel.max_distance = 1
		close_panel.max_distance = 1
	if music_volume != 0:
		back_ground.max_distance = 3000
		back_ground.attenuation= 20 - (19.9 * (music_volume / 100.0))
	else:
		back_ground.attenuation= 300
		back_ground.max_distance = 3000
func panel_popup(child):
	if child.visible:
		open_panel.play()
	else:
		close_panel.play()
