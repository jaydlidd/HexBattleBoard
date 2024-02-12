extends Control

@export var PORT = 4433
@export var ADDRESS = "127.0.0.1"

var peer

var player_inventory = ["knight", "farmer", "farmer"]

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# This gets called when a player connects on servers and clients
func player_connected(id):
	print("Player connected: " + str(id))

# This gets called when a player disconnects on servers and clients
func player_disconnected(id):
	print("Player disconnected: " + str(id))
	
# This is called only on a client
func connected_to_server():
	print("Connected to server!")
	send_player_info.rpc($PlayerNameTextEdit.text, multiplayer.get_unique_id(), player_inventory)
	
# This gets called only on a client
func connection_failed():
	print("Failed to connect to server!")

# Function to send player information to the games global variables
@rpc("any_peer")
func send_player_info(player_name, id, inventory):
	if !GlobalVars.players_ref.has(id):		# If there doesn't already exist a player with this id
		GlobalVars.players_ref[id] = {		# Create a new object with the ID as the key
			"player_name": player_name,
			"id": id,
			"inventory": inventory
		}
		
	if multiplayer.is_server():						# If the function is being called by the host server
		for player_id in GlobalVars.players_ref:	# Send player's information to all other players
			send_player_info.rpc(GlobalVars.players_ref[player_id].player_name, player_id)
	
@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://Scenes/Worlds/Main_Game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func _on_host_button_down():
	peer = ENetMultiplayerPeer.new()								# Start a peer connection
	var error = peer.create_server(PORT, 2)							# Create server with 2 players
	if error != OK:													# Handle errors
		print("Failure to set up host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)	# Compress traffic
	multiplayer.set_multiplayer_peer(peer)							# Use the host as our peer
	print("Waiting for players...")
	send_player_info($PlayerNameTextEdit.text, multiplayer.get_unique_id(), player_inventory)

func _on_connect_button_down():
	peer = ENetMultiplayerPeer.new()								# Start a peer connection
	peer.create_client(ADDRESS, PORT)								# Create a connection to the host
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)	# Compress traffic
	multiplayer.set_multiplayer_peer(peer)							# Allow the connection to play the game
	
func _on_start_game_button_down():
	start_game.rpc()
