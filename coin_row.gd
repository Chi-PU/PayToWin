extends Node2D

@export var coin_scene: PackedScene
@export var count:      int   = 4
@export var spacing:    float = 24.0  # pixels between each coin


func _ready() -> void:
	for i in count:
		var coin = coin_scene.instantiate()
		coin.position = Vector2(i * spacing, 0)
		add_child(coin)
