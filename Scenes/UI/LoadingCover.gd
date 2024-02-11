extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVars.game_settings["is_loading"] == false:		# If not loading...
		self.visible = false	# Hide loading screen
	else:													# If loading...
		self.visible = true		# Show loading screen
