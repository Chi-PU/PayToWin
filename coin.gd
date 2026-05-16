extends Area2D

signal collected

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collected.emit()
		_collect()


func _collect() -> void:
	# Prevent double-collect
	set_deferred("monitoring", false)

	# Register the coin with the manager ← this was missing
	CoinManager.add_coin()
	AudioManager.play_coin_sound()

	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	await get_tree().create_timer(0.05).timeout
	queue_free()
