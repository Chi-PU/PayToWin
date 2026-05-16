extends Node

signal coins_changed(new_coins: int)

var coins: int = 0

var jump_purchased:        bool = false
var go_left_purchased:     bool = false
var double_jump_purchased: bool = false

func _ready() -> void:
	reset()
	
func add_coin(value: int = 1) -> void:
	coins += value
	coins_changed.emit(coins)


func spend_coins(amount: int) -> bool:
	if coins < amount:
		return false
	coins -= amount
	coins_changed.emit(coins)
	return true


func reset() -> void:
	coins = 0
	jump_purchased        = false
	go_left_purchased     = false
	double_jump_purchased = false
	coins_changed.emit(coins)
	
	
func get_coins():
	return coins
