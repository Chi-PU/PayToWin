extends Camera2D

# How high the player must be above the camera before it follows up
@export var up_threshold:  float = 40.0

# How fast the camera lerps horizontally and upward
@export var follow_speed_x: float = 8.0
@export var follow_speed_y: float = 6.0


func _physics_process(delta: float) -> void:
	var player_pos: Vector2 = get_parent().global_position

	# ── X axis — always follow left and right ─────────────────
	var target_x := player_pos.x

	# ── Y axis — only follow upward, never downward ───────────
	# global_position here is the camera's current world position
	var target_y := global_position.y

	if player_pos.y < global_position.y - up_threshold:
		# Player is above the camera threshold — follow up
		target_y = player_pos.y + up_threshold

	# ── Smooth lerp toward target ─────────────────────────────
	global_position.x = lerp(global_position.x, target_x, follow_speed_x * delta)
	global_position.y = lerp(global_position.y, target_y, follow_speed_y * delta)
