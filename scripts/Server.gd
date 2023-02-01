extends Control

var port = 7777
var enet = ENetMultiplayerPeer.new()
var ipad

@export var pos : PackedVector2Array

func _ready() -> void:
	if OS.get_name() == "Windows":
		ipad = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ipad = IP.get_local_addresses()[0]
	else:
		ipad = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			ipad = ip
	$container/VBoxContainer/HSplitContainer/host/HBoxContainer/ip_text.text = "Ip Adress: " + str(ipad)

func _on_host_pressed() -> void:
	if OS.get_name() == "Android":
		enet.set_bind_ip(ipad)
	var err = enet.create_server(7777)
	if err != OK:
		$container/VBoxContainer/Error.text = "Couldnt Create A Server"
		return
	multiplayer.multiplayer_peer = enet
	add_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.server_disconnected.connect(server_delete)
	hide()

func server_delete():
	pass

func remove_player(id):
	#for child in %Players.get_children():
		#if child.name == str(id):
			#child.queue_free()
	pass

func _on_join_pressed() -> void:
	var err = enet.create_client($container/VBoxContainer/HSplitContainer/join/ip_port.text, 7777)
	await get_tree().create_timer(1).timeout
	print(str(err))
	if err != OK:
		$container/VBoxContainer/Error.text = "Couldnt Join The Server"
		return
	elif err == OK and err != 0:
		multiplayer.multiplayer_peer = enet
		hide()


func add_player(id):
	print(id)
	#var p_new = player.instantiate()
	#p_new.name = str(id)
	pass

func _on_ip_port_text_changed(new_text: String) -> void:
	$container/VBoxContainer/Error.text = ""


func _on_button_pressed() -> void:
	DisplayServer.clipboard_set(ipad)
