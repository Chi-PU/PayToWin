extends Node
## Audio Manager Singleton
## Manages audio playback with support for multiple simultaneous sounds
## Add this as an Autoload in Project Settings

# Preloaded audio files
var coin_sound: AudioStream
var jump_sound: AudioStream

# Pool of audio players for playing multiple sounds simultaneously
var audio_players: Array[AudioStreamPlayer] = []
var max_audio_players: int = 10  # Maximum number of simultaneous sounds

func _ready() -> void:
	# Preload audio files
	coin_sound = preload("res://SoundAsset/Sound effect/coin.wav")
	jump_sound = preload("res://SoundAsset/Sound effect/jump.wav")
	
	# Create a pool of audio players
	for i in range(max_audio_players):
		var player = AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		audio_players.append(player)

func play_sound(sound: AudioStream, volume_db: float = 0.0) -> void:
	"""
	Play a sound effect without stopping other sounds
	Args:
		sound: The AudioStream to play
		volume_db: Volume in decibels (0.0 = normal, negative = quieter, positive = louder)
	"""
	if sound == null:
		push_warning("AudioManager: Attempted to play null sound")
		return
	
	# Find an available audio player (not currently playing)
	for player in audio_players:
		if not player.playing:
			player.stream = sound
			player.volume_db = volume_db
			player.play()
			return
	
	# If all players are busy, play on the first one (will interrupt it)
	# This is a fallback to prevent sound loss
	audio_players[0].stream = sound
	audio_players[0].volume_db = volume_db
	audio_players[0].play()
	push_warning("AudioManager: All audio players are busy, sound may be cut off")

## Convenience methods for specific sounds
func play_coin_sound() -> void:
	"""Play the coin collection sound"""
	play_sound(coin_sound)

func play_jump_sound() -> void:
	"""Play the jump sound"""
	play_sound(jump_sound)
