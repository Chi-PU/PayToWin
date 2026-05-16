extends Node

var _player: CharacterBody2D = null
var _spawn_position: Vector2 = Vector2.ZERO


func register_player(player: CharacterBody2D) -> void:
	_player         = player
	_spawn_position = player.global_position


func handle_player_death() -> void:
	full_reset()


func full_reset() -> void:
	MenuManager.close_all()
	CoinManager.reset()          # ← clears coins + purchased abilities before reload
	get_tree().reload_current_scene()
