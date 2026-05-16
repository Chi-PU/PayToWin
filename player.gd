extends CharacterBody2D

const SPEED         := 220.0
const JUMP_VELOCITY := -420.0
const GRAVITY       := 980.0
const FALL_GRAVITY  := 1400.0
const COYOTE_TIME   := 0.12

var coyote_active:    bool  = false
var jump_buffer_time: float = 0.0
var jumps_remaining:  int   = 1

@onready var anim:         AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer            = $CoyoteTimer

var shop_scene       := preload("res://Scenes/buy_menu.tscn")
var pause_menu_scene := preload("res://Scenes/pause_menu.tscn")


func _ready() -> void:
	coyote_timer.timeout.connect(_on_coyote_timeout)
	add_to_group("player")
	GameManager.register_player(self)


func _physics_process(delta: float) -> void:
	if MenuManager.is_any_open():
		return
	_handle_gravity(delta)
	_handle_jump_input()
	_handle_movement()
	move_and_slide()
	_update_animation()


# ── Menus ─────────────────────────────────────────────────────
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") or event.is_action_pressed("backspace"):
		if not MenuManager.is_any_open():
			get_viewport().set_input_as_handled()
			_open_pause_menu()


func _open_pause_menu() -> void:
	var menu = pause_menu_scene.instantiate()
	get_tree().root.add_child(menu)


func _open_shop(ability: String, mandatory: bool = false) -> void:
	if MenuManager.is_any_open():
		return
	var popup       = shop_scene.instantiate()
	popup.ability   = ability
	popup.mandatory = mandatory
	get_tree().root.call_deferred("add_child", popup)


# ── Gravity ───────────────────────────────────────────────────
func _handle_gravity(delta: float) -> void:
	if is_on_floor():
		coyote_active   = true
		jumps_remaining = 1 if not CoinManager.double_jump_purchased else 2
		coyote_timer.stop()
	else:
		if coyote_active:
			coyote_timer.start(COYOTE_TIME)
			coyote_active = false
		var grav = FALL_GRAVITY if velocity.y > 0 else GRAVITY
		velocity.y += grav * delta


func _on_coyote_timeout() -> void:
	coyote_active = false


# ── Jump ──────────────────────────────────────────────────────
func _handle_jump_input() -> void:
	if not Input.is_action_just_pressed("jump"):
		return

	if not CoinManager.jump_purchased:
		_open_shop("jump")
		return

	var on_ground := is_on_floor() or coyote_active

	if on_ground:
		_do_jump(JUMP_VELOCITY)
	elif not CoinManager.double_jump_purchased:
		_open_shop("double_jump")
	elif jumps_remaining > 0:
		_do_jump(JUMP_VELOCITY * 0.85)


func _do_jump(force: float) -> void:
	AudioManager.play_jump_sound()
	velocity.y       = force
	jump_buffer_time = 0.0
	jumps_remaining -= 1
	coyote_active    = false
	coyote_timer.stop()


# ── Movement ──────────────────────────────────────────────────
func _handle_movement() -> void:
	var direction := 0.0

	if Input.is_action_pressed("ui_left"):
		if CoinManager.go_left_purchased:
			direction -= 1.0
		else:
			_open_shop("go_left")

	if Input.is_action_pressed("ui_right"):
		direction += 1.0

	velocity.x = direction * SPEED

	if direction != 0:
		anim.flip_h = direction < 0


# ── Animation ─────────────────────────────────────────────────
func _update_animation() -> void:
	var new_anim := "idle"

	if not is_on_floor():
		new_anim = "jump" if velocity.y < 0 else "fall"
	elif abs(velocity.x) > 10:
		new_anim = "run"

	if not anim.sprite_frames.has_animation(new_anim):
		new_anim = "idle"

	if anim.animation != new_anim:
		anim.play(new_anim)
